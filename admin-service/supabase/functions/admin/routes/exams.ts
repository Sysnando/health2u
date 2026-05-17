import { Hono } from "hono";
import { currentUser, requireAuth } from "../../_shared/auth.ts";
import { db } from "../../_shared/db.ts";
import { badRequest, internal, notFound, unprocessable } from "../../_shared/errors.ts";
import {
  buildExamKey,
  deleteObject,
  fetchObject,
  presignDownload,
  presignUpload,
  uploadObject,
} from "../../_shared/r2.ts";
import { examDto, analysisDto, type AnalysisRow } from "../../_shared/dto.ts";
import { analyzeDocument } from "../../_shared/ai.ts";

const app = new Hono();
app.use("*", requireAuth);

const EXAM_COLUMNS =
  "id, user_id, title, type, date, file_key, notes, created_at, updated_at";

app.get("/", async (c) => {
  const me = currentUser(c);
  const filter = c.req.query("filter");

  let q = db().from("exams").select(EXAM_COLUMNS).eq("user_id", me.id);
  if (filter) q = q.eq("type", filter);

  const { data, error } = await q.order("date", { ascending: false });
  if (error) return internal(c, error.message);

  const exams = data ?? [];
  const examIds = exams.map((e) => e.id);

  let analysisMap: Record<string, string> = {};
  if (examIds.length > 0) {
    const { data: analyses } = await db()
      .from("document_analyses")
      .select("exam_id, status")
      .in("exam_id", examIds);

    if (analyses) {
      for (const a of analyses) {
        analysisMap[a.exam_id] = a.status;
      }
    }
  }

  return c.json(
    exams.map((e) => ({
      ...examDto(e),
      analysis_status: analysisMap[e.id] ?? null,
    })),
  );
});

// Two-step upload, step 1: ask for a presigned PUT URL. Client uploads
// directly to R2, then calls POST / with the returned key + metadata.
app.post("/upload-url", async (c) => {
  const me = currentUser(c);
  const body = await c.req.json().catch(() => ({}));
  const { filename, content_type } = body;

  if (!filename || typeof filename !== "string") {
    return badRequest(c, "filename is required");
  }

  const key = buildExamKey(me.id, filename);
  const uploadUrl = await presignUpload(key, content_type ?? "application/octet-stream");
  return c.json({ upload_url: uploadUrl, key, expires_in: 300 });
});

// Single-step upload: client sends file + metadata as multipart form data.
// Flow: validate -> upload to storage -> analyze with OpenAI -> branch:
//   * not_medical: delete storage object, return 422, no DB rows created.
//   * otherwise:   insert exam row + completed analysis row, return 201.
// AI failures (network/timeout/etc.) still insert the exam + a failed analysis
// row so the client can retry via POST /:id/analyze.
app.post("/upload", async (c) => {
  const me = currentUser(c);
  const body = await c.req.parseBody();

  const file = body["file"];
  const title = body["title"] as string | undefined;
  const type = body["type"] as string | undefined;
  const dateStr = body["date"] as string | undefined;
  const notes = body["notes"] as string | undefined;

  if (!title || !type || !dateStr) {
    return badRequest(c, "Missing required fields: title, type, date");
  }
  if (!(file instanceof File)) {
    return badRequest(c, "Missing file");
  }

  const fileBytes = new Uint8Array(await file.arrayBuffer());
  const key = buildExamKey(me.id, file.name || "upload");
  const contentType = file.type || "application/octet-stream";

  await uploadObject(key, fileBytes, contentType);

  // Run AI analysis BEFORE inserting any DB rows so we can hard-reject
  // non-medical uploads without leaving orphaned rows.
  let aiResult: Awaited<ReturnType<typeof analyzeDocument>> | null = null;
  let aiError: string | null = null;
  try {
    aiResult = await analyzeDocument(fileBytes, contentType);
  } catch (err: unknown) {
    aiError = err instanceof Error ? err.message : String(err);
  }

  if (aiResult && aiResult.document_type === "not_medical") {
    // Delete the uploaded object so the bucket doesn't keep orphans.
    try {
      await deleteObject(key);
    } catch (err) {
      console.error("Failed to delete rejected upload:", err);
    }
    return unprocessable(
      c,
      "NOT_A_MEDICAL_DOCUMENT",
      aiResult.rejection_reason ?? "Not a medical document",
    );
  }

  const { data, error } = await db()
    .from("exams")
    .insert({
      user_id: me.id,
      title,
      type,
      date: Number(dateStr),
      file_key: key,
      notes: notes || null,
    })
    .select(EXAM_COLUMNS)
    .single();

  if (error) return internal(c, error.message);

  if (aiResult) {
    await db()
      .from("document_analyses")
      .insert({
        exam_id: data.id,
        user_id: me.id,
        status: "completed",
        document_type: aiResult.document_type,
        summary: aiResult.summary,
        language: aiResult.language,
        extracted_data: aiResult.extracted_data,
        raw_ai_response: aiResult.raw_response,
        model_used: aiResult.model,
      });
  } else {
    await db()
      .from("document_analyses")
      .insert({
        exam_id: data.id,
        user_id: me.id,
        status: "failed",
        error_message: aiError,
      });
  }

  const { data: analysisRow } = await db()
    .from("document_analyses")
    .select("*")
    .eq("exam_id", data.id)
    .single();

  const analysis = analysisRow ? analysisDto(analysisRow as AnalysisRow) : null;
  return c.json({ ...examDto(data), analysis }, 201);
});

// Two-step upload, step 2: create the exam record after the client has
// PUT the file using the presigned URL above. Same not_medical branching as
// /upload: if OpenAI rejects the file we delete the already-uploaded object
// and return 422 with no exam row created.
app.post("/", async (c) => {
  const me = currentUser(c);
  const body = await c.req.json().catch(() => ({}));
  const { title, type, date, notes, key } = body;

  if (!title || !type || date == null) {
    return badRequest(c, "Missing required fields: title, type, date");
  }

  // If a file key was attached, analyze BEFORE creating any DB rows so we
  // can cleanly reject non-medical uploads.
  let aiResult: Awaited<ReturnType<typeof analyzeDocument>> | null = null;
  let aiError: string | null = null;

  if (key) {
    try {
      const file = await fetchObject(key);
      aiResult = await analyzeDocument(file.body, file.contentType);
    } catch (err: unknown) {
      aiError = err instanceof Error ? err.message : String(err);
    }

    if (aiResult && aiResult.document_type === "not_medical") {
      try {
        await deleteObject(key);
      } catch (err) {
        console.error("Failed to delete rejected upload:", err);
      }
      return unprocessable(
        c,
        "NOT_A_MEDICAL_DOCUMENT",
        aiResult.rejection_reason ?? "Not a medical document",
      );
    }
  }

  const { data, error } = await db()
    .from("exams")
    .insert({
      user_id: me.id,
      title,
      type,
      date: Number(date),
      file_key: key ?? null,
      notes: notes ?? null,
    })
    .select(EXAM_COLUMNS)
    .single();

  if (error) return internal(c, error.message);

  let analysis = null;

  if (key) {
    if (aiResult) {
      await db()
        .from("document_analyses")
        .insert({
          exam_id: data.id,
          user_id: me.id,
          status: "completed",
          document_type: aiResult.document_type,
          summary: aiResult.summary,
          language: aiResult.language,
          extracted_data: aiResult.extracted_data,
          raw_ai_response: aiResult.raw_response,
          model_used: aiResult.model,
        });
    } else {
      await db()
        .from("document_analyses")
        .insert({
          exam_id: data.id,
          user_id: me.id,
          status: "failed",
          error_message: aiError,
        });
    }

    const { data: analysisRow } = await db()
      .from("document_analyses")
      .select("*")
      .eq("exam_id", data.id)
      .single();

    if (analysisRow) {
      analysis = analysisDto(analysisRow as AnalysisRow);
    }
  }

  return c.json({ ...examDto(data), analysis }, 201);
});

app.get("/:id", async (c) => {
  const me = currentUser(c);
  const { data, error } = await db()
    .from("exams")
    .select(EXAM_COLUMNS)
    .eq("id", c.req.param("id"))
    .eq("user_id", me.id)
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "Exam not found");

  const { data: analysis } = await db()
    .from("document_analyses")
    .select("*")
    .eq("exam_id", data.id)
    .maybeSingle();

  return c.json({
    ...examDto(data),
    analysis: analysis ? analysisDto(analysis as AnalysisRow) : null,
  });
});

// Short-lived presigned GET so the client can download the file.
app.get("/:id/file", async (c) => {
  const me = currentUser(c);
  const { data, error } = await db()
    .from("exams")
    .select("file_key")
    .eq("id", c.req.param("id"))
    .eq("user_id", me.id)
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "Exam not found");
  if (!data.file_key) return notFound(c, "Exam has no file attached");

  const url = await presignDownload(data.file_key);
  return c.json({ url, expires_in: 300 });
});

// Retry AI analysis for an exam.
// Unlike /upload and /, this endpoint NEVER returns 422 / deletes files —
// the user has already curated this exam, so a fresh not_medical verdict on
// retry is coerced to document_type="other" with the rejection reason stored
// as the summary, so the user still sees feedback without losing data.
app.post("/:id/analyze", async (c) => {
  const me = currentUser(c);
  const { data, error } = await db()
    .from("exams")
    .select(EXAM_COLUMNS)
    .eq("id", c.req.param("id"))
    .eq("user_id", me.id)
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "Exam not found");
  if (!data.file_key) return badRequest(c, "Exam has no file to analyze");

  // Delete any existing analysis row
  await db()
    .from("document_analyses")
    .delete()
    .eq("exam_id", data.id);

  // Insert new processing row
  await db()
    .from("document_analyses")
    .insert({ exam_id: data.id, user_id: me.id, status: "processing" });

  try {
    const file = await fetchObject(data.file_key);
    const result = await analyzeDocument(file.body, file.contentType);

    // On retry, never reject the file — coerce not_medical to "other" and
    // surface the rejection reason as the summary so the user sees it.
    const isRejected = result.document_type === "not_medical";
    const documentType = isRejected ? "other" : result.document_type;
    const summary = isRejected
      ? (result.rejection_reason ?? result.summary ?? "Not a medical document")
      : result.summary;
    const extractedData = isRejected
      ? { content: result.rejection_reason ?? "Not a medical document" }
      : result.extracted_data;

    await db()
      .from("document_analyses")
      .update({
        status: "completed",
        document_type: documentType,
        summary,
        language: result.language,
        extracted_data: extractedData,
        raw_ai_response: result.raw_response,
        model_used: result.model,
      })
      .eq("exam_id", data.id);
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : String(err);
    await db()
      .from("document_analyses")
      .update({ status: "failed", error_message: message })
      .eq("exam_id", data.id);
  }

  const { data: analysisRow } = await db()
    .from("document_analyses")
    .select("*")
    .eq("exam_id", data.id)
    .single();

  const analysis = analysisRow ? analysisDto(analysisRow as AnalysisRow) : null;
  return c.json({ ...examDto(data), analysis });
});

app.delete("/:id", async (c) => {
  const me = currentUser(c);
  const { data, error } = await db()
    .from("exams")
    .delete()
    .eq("id", c.req.param("id"))
    .eq("user_id", me.id)
    .select("id")
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "Exam not found");
  return c.body(null, 204);
});

export default app;
