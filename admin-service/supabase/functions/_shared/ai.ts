import OpenAI from "openai";
import { env } from "./env.ts";

const MODEL = "gpt-4o";

const SYSTEM_PROMPT = `You are a medical document analysis assistant. Analyze the provided file and return ONLY valid JSON (no markdown, no code fences, no extra text).

Your response must be a JSON object with exactly these fields:
{
  "document_type": "lab_results" | "prescription" | "imaging_report" | "other" | "not_medical",
  "language": "ISO 639-1 code of the document's primary language (en, pt, es, fr, de, it, ...)",
  "summary": "2-3 sentence plain-language summary of the document",
  "rejection_reason": "short reason when document_type is not_medical (e.g. 'Receipt', 'Personal photo', 'Screenshot of website'); null otherwise",
  "extracted_data": { ... }
}

Step 1 — classify:
- "lab_results": laboratory test results, blood work, urinalysis, pathology reports.
- "prescription": medication prescriptions or pharmacy labels.
- "imaging_report": radiology / imaging reports (X-ray, MRI, CT, ultrasound, etc.).
- "other": medical content that doesn't fit the above (e.g. discharge summaries, clinical notes, vaccination records).
- "not_medical": the file has NO medical content. Examples: receipts, invoices, screenshots of websites or apps, ID cards, personal photos (selfies, pets, landscapes), contracts, marketing material, blank pages, random text, social media screenshots, anything without medical information.

Step 2 — language:
- Detect the document's primary written language and return its ISO 639-1 code.
- Write the "summary" in the same language as the document. If the document is in Portuguese, the summary must be in Portuguese; if Spanish, in Spanish; etc.

Step 3 — extract:
- When document_type is "not_medical", set "extracted_data" to {} and provide a short "rejection_reason".
- Otherwise, set "rejection_reason" to null and populate "extracted_data" using the schema for the chosen document_type.

Schemas by document_type:

For "lab_results":
{"patient_name": "string|null", "test_date": "YYYY-MM-DD|null", "lab_name": "string|null", "results": [{"test_name": "string", "value": "string", "unit": "string|null", "reference_range": "string|null", "flag": "normal|high|low|null"}]}

For "prescription":
{"prescriber": "string|null", "date": "YYYY-MM-DD|null", "medications": [{"name": "string", "dosage": "string|null", "frequency": "string|null", "duration": "string|null"}]}

For "imaging_report":
{"modality": "string|null", "body_part": "string|null", "findings": "string|null", "impression": "string|null"}

For "other":
{"content": "string (free-text extraction of key information)"}

For "not_medical":
{}

Rules:
- Extract only what is explicitly present in the document. Use null for missing fields.
- Dates must be in YYYY-MM-DD format when present.
- Write summary in the same language as the document.
- Return ONLY the JSON object, nothing else.`;

export interface AnalysisResult {
  document_type: string;
  language: string | null;
  summary: string;
  rejection_reason: string | null;
  extracted_data: Record<string, unknown>;
  raw_response: unknown;
  model: string;
}

const SUPPORTED_IMAGE_TYPES = new Set<string>([
  "image/jpeg",
  "image/png",
  "image/gif",
  "image/webp",
]);

function toBase64(bytes: Uint8Array): string {
  let binary = "";
  for (let i = 0; i < bytes.length; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return btoa(binary);
}

export async function analyzeDocument(
  fileBytes: Uint8Array,
  contentType: string,
): Promise<AnalysisResult> {
  const client = new OpenAI({ apiKey: env.openaiApiKey });
  const base64Data = toBase64(fileBytes);

  // OpenAI chat completions accept images via image_url (base64 data URI) and
  // PDFs via the `file` content type with a base64 file_data data URI.
  // deno-lint-ignore no-explicit-any
  let contentBlock: any;

  if (SUPPORTED_IMAGE_TYPES.has(contentType)) {
    contentBlock = {
      type: "image_url",
      image_url: {
        url: `data:${contentType};base64,${base64Data}`,
      },
    };
  } else if (contentType === "application/pdf") {
    contentBlock = {
      type: "file",
      file: {
        filename: "document.pdf",
        file_data: `data:application/pdf;base64,${base64Data}`,
      },
    };
  } else {
    throw new Error(`Unsupported content type for AI analysis: ${contentType}`);
  }

  const response = await client.chat.completions.create({
    model: MODEL,
    max_tokens: 4096,
    response_format: { type: "json_object" },
    messages: [
      { role: "system", content: SYSTEM_PROMPT },
      {
        role: "user",
        content: [
          contentBlock,
          {
            type: "text",
            text: "Analyze this medical document and return the structured JSON.",
          },
        ],
      },
    ],
  });

  const text = response.choices[0]?.message?.content;
  if (!text) {
    throw new Error("No text response from OpenAI API");
  }

  const parsed = JSON.parse(text);

  return {
    document_type: parsed.document_type,
    language: typeof parsed.language === "string" ? parsed.language : null,
    summary: parsed.summary,
    rejection_reason:
      typeof parsed.rejection_reason === "string" ? parsed.rejection_reason : null,
    extracted_data: parsed.extracted_data ?? {},
    raw_response: response,
    model: MODEL,
  };
}
