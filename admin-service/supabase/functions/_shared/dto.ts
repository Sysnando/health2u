// DTO shaping: the mobile client expects epoch-millis timestamps, snake_case
// columns, and specific field names that don't match the DB 1:1. These
// helpers keep the wire format stable.

import type { AuthUser } from "./auth.ts";

export interface UserRow {
  id: string;
  email: string;
  name: string;
  phone: string | null;
  date_of_birth: number | null;
  profile_picture_url: string | null;
  password_hash: string;
  gender: string | null;
  height_cm: number | null;
  weight_kg: number | null;
  blood_type: string | null;
}

export function userDto(u: UserRow) {
  // Strip password_hash; everything else ships as-is.
  const { password_hash: _ph, ...dto } = u;
  return dto;
}

export interface ExamRow {
  id: string;
  user_id: string;
  title: string;
  type: string;
  date: number;
  file_key: string | null;
  notes: string | null;
  created_at: string; // timestamptz
  updated_at: string;
}

export function examDto(e: ExamRow) {
  // The original API exposed file_url. We keep that field name for
  // backwards-compat — it now holds the R2 object key.
  const { file_key, created_at, updated_at, ...rest } = e;
  return {
    ...rest,
    file_url: file_key,
    created_at: new Date(created_at).getTime(),
    updated_at: new Date(updated_at).getTime(),
  };
}

export interface AnalysisRow {
  id: string;
  exam_id: string;
  user_id: string;
  status: string;
  document_type: string | null;
  summary: string | null;
  extracted_data: Record<string, unknown> | null;
  raw_ai_response: unknown;
  model_used: string | null;
  error_message: string | null;
  created_at: string;
  updated_at: string;
}

export function analysisDto(a: AnalysisRow) {
  const { raw_ai_response: _raw, created_at, updated_at, ...rest } = a;
  return {
    ...rest,
    created_at: new Date(created_at).getTime(),
    updated_at: new Date(updated_at).getTime(),
  };
}

export function insightDto(row: any) {
  return {
    id: row.id,
    user_id: row.user_id,
    type: row.type,
    title: row.title,
    description: row.description,
    metric_value: row.metric_value,
    timestamp: typeof row.timestamp === "string" ? new Date(row.timestamp).getTime() : row.timestamp,
    created_at: new Date(row.created_at).getTime(),
  };
}

export { type AuthUser };
