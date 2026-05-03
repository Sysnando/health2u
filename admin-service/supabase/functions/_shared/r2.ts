import { GetObjectCommand, PutObjectCommand, S3Client } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";
import { env } from "./env.ts";

// Cloudflare R2 is S3-compatible. The endpoint is
// https://<account_id>.r2.cloudflarestorage.com and the region is always "auto".
let client: S3Client | null = null;

function r2Client(): S3Client {
  if (!client) {
    client = new S3Client({
      region: "auto",
      endpoint: `https://${env.r2AccountId}.r2.cloudflarestorage.com`,
      credentials: {
        accessKeyId: env.r2AccessKeyId,
        secretAccessKey: env.r2SecretAccessKey,
      },
    });
  }
  return client;
}

// Presigned PUT the mobile client uses to upload a file directly to R2.
// ExpiresIn is short because the client should upload immediately.
export function presignUpload(
  key: string,
  contentType: string,
  expiresInSeconds = 300,
): Promise<string> {
  return getSignedUrl(
    r2Client(),
    new PutObjectCommand({
      Bucket: env.r2Bucket,
      Key: key,
      ContentType: contentType,
    }),
    { expiresIn: expiresInSeconds },
  );
}

// Presigned GET for reading an already-uploaded file.
export function presignDownload(
  key: string,
  expiresInSeconds = 300,
): Promise<string> {
  return getSignedUrl(
    r2Client(),
    new GetObjectCommand({
      Bucket: env.r2Bucket,
      Key: key,
    }),
    { expiresIn: expiresInSeconds },
  );
}

// Fetch a file from R2 server-side (used by AI document analysis).
export async function fetchObject(
  key: string,
): Promise<{ body: Uint8Array; contentType: string }> {
  const response = await r2Client().send(
    new GetObjectCommand({
      Bucket: env.r2Bucket,
      Key: key,
    }),
  );

  const body = await response.Body?.transformToByteArray();
  if (!body) {
    throw new Error(`Empty body for R2 object: ${key}`);
  }

  return {
    body,
    contentType: response.ContentType ?? "application/octet-stream",
  };
}

// Build an opaque-ish but human-debuggable object key.
export function buildExamKey(userId: string, originalName: string): string {
  const ts = Date.now();
  const safe = originalName.replace(/[^a-zA-Z0-9._-]/g, "_");
  return `exams/${userId}/${ts}_${safe}`;
}

export function buildProfilePhotoKey(userId: string, filename: string): string {
  const ts = Date.now();
  const safe = filename.replace(/[^a-zA-Z0-9._-]/g, "_");
  return `profiles/${userId}/${ts}_${safe}`;
}
