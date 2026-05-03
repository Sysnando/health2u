import Anthropic from "@anthropic-ai/sdk";
import { env } from "./env.ts";

const MODEL = "claude-sonnet-4-20250514";

const SYSTEM_PROMPT = `You are a medical document analysis assistant. Analyze the provided medical document and return ONLY valid JSON (no markdown, no code fences, no extra text).

Your response must be a JSON object with exactly these fields:
{
  "document_type": "lab_results" | "prescription" | "imaging_report" | "other",
  "summary": "2-3 sentence plain-language summary of the document",
  "extracted_data": { ... }
}

Choose the document_type that best matches the document content, then extract structured data according to the schema for that type.

Schemas by document_type:

For "lab_results":
{"patient_name": "string|null", "test_date": "YYYY-MM-DD|null", "lab_name": "string|null", "results": [{"test_name": "string", "value": "string", "unit": "string|null", "reference_range": "string|null", "flag": "normal|high|low|null"}]}

For "prescription":
{"prescriber": "string|null", "date": "YYYY-MM-DD|null", "medications": [{"name": "string", "dosage": "string|null", "frequency": "string|null", "duration": "string|null"}]}

For "imaging_report":
{"modality": "string|null", "body_part": "string|null", "findings": "string|null", "impression": "string|null"}

For "other":
{"content": "string (free-text extraction of key information)"}

Rules:
- Extract only what is explicitly present in the document. Use null for missing fields.
- Dates must be in YYYY-MM-DD format when present.
- Return ONLY the JSON object, nothing else.`;

export interface AnalysisResult {
  document_type: string;
  summary: string;
  extracted_data: Record<string, unknown>;
  raw_response: unknown;
  model: string;
}

type ImageMediaType = "image/jpeg" | "image/png" | "image/gif" | "image/webp";

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
  const client = new Anthropic({ apiKey: env.anthropicApiKey });
  const base64Data = toBase64(fileBytes);

  let contentBlock: Anthropic.Messages.ContentBlockParam;

  if (SUPPORTED_IMAGE_TYPES.has(contentType)) {
    contentBlock = {
      type: "image",
      source: {
        type: "base64",
        media_type: contentType as ImageMediaType,
        data: base64Data,
      },
    };
  } else if (contentType === "application/pdf") {
    contentBlock = {
      type: "document",
      source: {
        type: "base64",
        media_type: "application/pdf",
        data: base64Data,
      },
    };
  } else {
    throw new Error(`Unsupported content type for AI analysis: ${contentType}`);
  }

  const response = await client.messages.create({
    model: MODEL,
    max_tokens: 4096,
    system: SYSTEM_PROMPT,
    messages: [
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

  const textBlock = response.content.find((b) => b.type === "text");
  if (!textBlock || textBlock.type !== "text") {
    throw new Error("No text response from Claude API");
  }

  const parsed = JSON.parse(textBlock.text);

  return {
    document_type: parsed.document_type,
    summary: parsed.summary,
    extracted_data: parsed.extracted_data,
    raw_response: response,
    model: MODEL,
  };
}
