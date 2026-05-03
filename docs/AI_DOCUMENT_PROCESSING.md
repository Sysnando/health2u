# AI Document Upload & Processing

## Context

Users upload medical documents (photos/PDFs of lab results, prescriptions, imaging reports) via the mobile apps. Currently, files are stored in R2 but not interpreted. This feature adds AI-powered extraction using the Claude API to read documents, extract structured medical data, and store the results in the database alongside the raw file.

## Architecture Decision

**Synchronous processing** during `POST /exams` (not async). Rationale:
- Supabase Edge Functions allow 60s+ timeouts
- Claude vision calls complete in 5-15s for a single document
- Avoids the complexity of async queues/workers
- Schema supports future migration to async if needed (status column + retry endpoint)

**Separate `document_analyses` table** (not columns on `exams`). Rationale:
- `extracted_data` JSONB can be large; avoid loading on list queries
- Analysis has its own lifecycle (status, retries, errors)
- Exam creation never fails due to AI issues

## Implementation Steps

### 1. Database Migration — `admin-service/supabase/migrations/0003_document_analyses.sql`

```sql
create table public.document_analyses (
  id              uuid primary key default gen_random_uuid(),
  exam_id         uuid not null references public.exams(id) on delete cascade,
  user_id         uuid not null references public.users(id) on delete cascade,
  status          text not null default 'pending'
                  check (status in ('pending', 'processing', 'completed', 'failed')),
  document_type   text,          -- lab_results | prescription | imaging_report | other
  summary         text,          -- plain-language summary
  extracted_data  jsonb,         -- structured extraction (schema varies by document_type)
  raw_ai_response jsonb,         -- full Claude response for audit
  model_used      text,
  error_message   text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create unique index document_analyses_exam_id_idx on public.document_analyses(exam_id);
create index document_analyses_user_id_idx on public.document_analyses(user_id);

alter table public.document_analyses enable row level security;

create trigger document_analyses_set_updated_at
  before update on public.document_analyses
  for each row execute function public.set_updated_at();
```

### 2. Add Anthropic SDK — `admin-service/supabase/functions/deno.json`

Add to imports:
```json
"@anthropic-ai/sdk": "npm:@anthropic-ai/sdk@^0.39.0"
```

### 3. Add env var — `admin-service/supabase/functions/_shared/env.ts`

```typescript
anthropicApiKey: required("ANTHROPIC_API_KEY"),
```

### 4. Add R2 fetch helper — `admin-service/supabase/functions/_shared/r2.ts`

New `fetchObject(key)` function using `GetObjectCommand` (already imported) to get file bytes server-side. Returns `{ body: Uint8Array, contentType: string }`.

### 5. Create AI module — `admin-service/supabase/functions/_shared/ai.ts`

New file with:
- `analyzeDocument(fileBytes: Uint8Array, contentType: string): Promise<AnalysisResult>`
- Uses `@anthropic-ai/sdk` with `ANTHROPIC_API_KEY`
- Sends document as image (JPG/PNG) or document (PDF) content block
- System prompt instructs Claude to: identify document type, extract structured data, provide summary, return JSON
- Returns `{ document_type, summary, extracted_data, raw_response, model }`

**Extracted data schemas by document_type:**

`lab_results`:
```json
{
  "patient_name": "string",
  "test_date": "string (YYYY-MM-DD)",
  "lab_name": "string",
  "results": [
    {
      "test_name": "string",
      "value": "string",
      "unit": "string",
      "reference_range": "string",
      "flag": "normal | high | low"
    }
  ]
}
```

`prescription`:
```json
{
  "prescriber": "string",
  "date": "string (YYYY-MM-DD)",
  "medications": [
    {
      "name": "string",
      "dosage": "string",
      "frequency": "string",
      "duration": "string"
    }
  ]
}
```

`imaging_report`:
```json
{
  "modality": "string (e.g. MRI, CT, X-Ray)",
  "body_part": "string",
  "findings": "string",
  "impression": "string"
}
```

### 6. Extend DTOs — `admin-service/supabase/functions/_shared/dto.ts`

Add `analysisDto()` function and `AnalysisRow` interface. Shape timestamps to epoch ms.

### 7. Modify exam routes — `admin-service/supabase/functions/admin/routes/exams.ts`

**Modify `POST /`:** After inserting exam, if `key` is present:
1. Insert `document_analyses` row with `status = 'processing'`
2. Fetch file from R2 via `fetchObject(key)`
3. Call `analyzeDocument()`
4. Update `document_analyses` with results and `status = 'completed'`
5. On failure: set `status = 'failed'`, `error_message`, still return the exam
6. Return exam DTO with analysis included

**Add `POST /:id/analyze`:** Retry endpoint for failed/missing analyses. Same flow as above but reads existing exam's `file_key`.

**Modify `GET /:id`:** Left-join `document_analyses` to include analysis in response.

**Modify `GET /`:** Add `analysis_status` to list response (lightweight — no full extracted_data).

### 8. Update .env.example

Add `ANTHROPIC_API_KEY` placeholder.

## Files to Create

| File | Purpose |
|------|---------|
| `admin-service/supabase/migrations/0003_document_analyses.sql` | Schema |
| `admin-service/supabase/functions/_shared/ai.ts` | Claude API integration |

## Files to Modify

| File | Change |
|------|--------|
| `admin-service/supabase/functions/deno.json` | Add `@anthropic-ai/sdk` |
| `admin-service/supabase/functions/_shared/env.ts` | Add `anthropicApiKey` |
| `admin-service/supabase/functions/_shared/r2.ts` | Add `fetchObject()` |
| `admin-service/supabase/functions/_shared/dto.ts` | Add `analysisDto()` |
| `admin-service/supabase/functions/admin/routes/exams.ts` | AI processing in POST, retry endpoint, join in GET |
| `admin-service/.env.example` | Add `ANTHROPIC_API_KEY` |

## Error Handling

- AI failure never blocks exam creation — file is always stored
- Failed analyses get `status = 'failed'` with `error_message`
- Client can retry via `POST /exams/:id/analyze`
- Unsupported file types skip analysis gracefully

## Security

- `ANTHROPIC_API_KEY` via `supabase secrets set`, never committed
- No PHI in logs — only log status transitions
- `raw_ai_response` stored for audit, protected by RLS + service-role access
- All connections TLS (R2 -> Edge Function -> Anthropic API)

## Verification

1. Start local Supabase: `supabase start && supabase db reset`
2. Serve functions: `supabase functions serve admin --env-file .env --no-verify-jwt`
3. Upload a lab result image via `POST /exams/upload-url` + R2 PUT + `POST /exams`
4. Verify response includes `analysis` with `status: 'completed'` and extracted data
5. Verify `GET /exams/:id` returns the analysis
6. Test failure: upload with invalid file type, verify exam created with `analysis.status: 'failed'`
7. Test retry: `POST /exams/:id/analyze` on a failed analysis
