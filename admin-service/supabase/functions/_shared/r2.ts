import { db } from "./db.ts";

// Storage helpers using Supabase Storage instead of Cloudflare R2.
// Supabase Storage avoids the TLS handshake failures that the R2 S3 endpoint
// causes for both iOS clients and Deno edge functions.

const EXAM_BUCKET = "exam-files";
const PROFILE_BUCKET = "profile-photos";

// Upload a file to Supabase Storage.
export async function uploadObject(
  key: string,
  body: Uint8Array,
  contentType: string,
): Promise<void> {
  const bucket = key.startsWith("profiles/") ? PROFILE_BUCKET : EXAM_BUCKET;
  const { error } = await db().storage.from(bucket).upload(key, body, {
    contentType,
    upsert: true,
  });
  if (error) throw new Error(`Storage upload failed: ${error.message}`);
}

// Fetch a file from Supabase Storage (used by AI document analysis).
export async function fetchObject(
  key: string,
): Promise<{ body: Uint8Array; contentType: string }> {
  const bucket = key.startsWith("profiles/") ? PROFILE_BUCKET : EXAM_BUCKET;
  const { data, error } = await db().storage.from(bucket).download(key);
  if (error || !data) {
    throw new Error(`Storage download failed: ${error?.message ?? "empty body"}`);
  }

  const arrayBuffer = await data.arrayBuffer();
  return {
    body: new Uint8Array(arrayBuffer),
    contentType: data.type || "application/octet-stream",
  };
}

// Create a short-lived signed URL for the client to download a file.
export async function presignDownload(
  key: string,
  expiresInSeconds = 300,
): Promise<string> {
  const bucket = key.startsWith("profiles/") ? PROFILE_BUCKET : EXAM_BUCKET;
  const { data, error } = await db().storage.from(bucket).createSignedUrl(key, expiresInSeconds);
  if (error || !data?.signedUrl) {
    throw new Error(`Signed URL failed: ${error?.message ?? "no URL returned"}`);
  }
  return data.signedUrl;
}

// Legacy presignUpload kept for backwards compatibility with the /upload-url
// endpoint — but mobile clients should prefer POST /exams/upload instead.
export async function presignUpload(
  key: string,
  _contentType: string,
  expiresInSeconds = 300,
): Promise<string> {
  const bucket = key.startsWith("profiles/") ? PROFILE_BUCKET : EXAM_BUCKET;
  const { data, error } = await db().storage.from(bucket).createSignedUploadUrl(key);
  if (error || !data) {
    throw new Error(`Signed upload URL failed: ${error?.message ?? "no URL returned"}`);
  }
  return data.signedUrl;
}

// Build an opaque-ish but human-debuggable object key.
export function buildExamKey(userId: string, originalName: string): string {
  const ts = Date.now();
  const safe = originalName.replace(/[^a-zA-Z0-9._-]/g, "_");
  return `${userId}/${ts}_${safe}`;
}

export function buildProfilePhotoKey(userId: string, filename: string): string {
  const ts = Date.now();
  const safe = filename.replace(/[^a-zA-Z0-9._-]/g, "_");
  return `${userId}/${ts}_${safe}`;
}
