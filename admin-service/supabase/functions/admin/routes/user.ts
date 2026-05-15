import { Hono } from "hono";
import { currentUser, requireAuth } from "../../_shared/auth.ts";
import { db } from "../../_shared/db.ts";
import { badRequest, internal, notFound } from "../../_shared/errors.ts";
import { userDto } from "../../_shared/dto.ts";
import { buildProfilePhotoKey, presignUpload, uploadObject } from "../../_shared/r2.ts";

const app = new Hono();
app.use("*", requireAuth);

const USER_COLUMNS =
  "id, email, password_hash, name, phone, date_of_birth, profile_picture_url, gender, height_cm, weight_kg, blood_type";

app.get("/profile", async (c) => {
  const me = currentUser(c);
  const { data, error } = await db()
    .from("users")
    .select(USER_COLUMNS)
    .eq("id", me.id)
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "User not found");
  return c.json(userDto(data));
});

app.post("/profile/photo-upload-url", async (c) => {
  const me = currentUser(c);
  const body = await c.req.json().catch(() => ({}));
  const { filename, content_type } = body;

  if (!filename || typeof filename !== "string") {
    return badRequest(c, "filename is required");
  }

  const key = buildProfilePhotoKey(me.id, filename);
  const uploadUrl = await presignUpload(key, content_type ?? "image/jpeg");
  return c.json({ upload_url: uploadUrl, key, expires_in: 300 });
});

// Proxy photo upload: client sends multipart form data, backend stores to
// Supabase Storage and updates the profile in one step.
app.post("/profile/photo-upload", async (c) => {
  const me = currentUser(c);
  const body = await c.req.parseBody();

  const file = body["file"];
  if (!(file instanceof File)) {
    return badRequest(c, "Missing file");
  }

  const fileBytes = new Uint8Array(await file.arrayBuffer());
  const key = buildProfilePhotoKey(me.id, file.name || "photo.jpg");
  const contentType = file.type || "image/jpeg";

  await uploadObject(key, fileBytes, contentType);

  const { data, error } = await db()
    .from("users")
    .update({ profile_picture_url: key })
    .eq("id", me.id)
    .select(USER_COLUMNS)
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "User not found");
  return c.json(userDto(data));
});

app.put("/profile", async (c) => {
  const me = currentUser(c);
  const body = await c.req.json().catch(() => ({}));

  // Explicit allowlist; silently drop anything else.
  const allowed = ["name", "profile_picture_url", "date_of_birth", "phone", "email", "gender", "height_cm", "weight_kg", "blood_type"] as const;
  const patch: Record<string, unknown> = {};
  for (const f of allowed) {
    if (body[f] !== undefined) patch[f] = body[f];
  }

  if (Object.keys(patch).length === 0) {
    // Nothing to do — return current state.
    const { data, error } = await db()
      .from("users")
      .select(USER_COLUMNS)
      .eq("id", me.id)
      .maybeSingle();
    if (error) return internal(c, error.message);
    if (!data) return notFound(c, "User not found");
    return c.json(userDto(data));
  }

  const { data, error } = await db()
    .from("users")
    .update(patch)
    .eq("id", me.id)
    .select(USER_COLUMNS)
    .maybeSingle();

  if (error) return internal(c, error.message);
  if (!data) return notFound(c, "User not found");
  return c.json(userDto(data));
});

export default app;
