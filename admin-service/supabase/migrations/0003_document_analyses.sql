-- AI document analysis results linked to exams.
-- Each exam can have at most one analysis (unique index on exam_id).

-- ── document_analyses ─────────────────────────────────────────────────
create table public.document_analyses (
  id              uuid primary key default gen_random_uuid(),
  exam_id         uuid not null references public.exams(id) on delete cascade,
  user_id         uuid not null references public.users(id) on delete cascade,
  status          text not null default 'pending'
                  check (status in ('pending', 'processing', 'completed', 'failed')),
  document_type   text,
  summary         text,
  extracted_data  jsonb,
  raw_ai_response jsonb,
  model_used      text,
  error_message   text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create unique index document_analyses_exam_id_idx on public.document_analyses(exam_id);
create index document_analyses_user_id_idx on public.document_analyses(user_id);

-- ── RLS ───────────────────────────────────────────────────────────────
alter table public.document_analyses enable row level security;

-- ── updated_at trigger ────────────────────────────────────────────────
create trigger document_analyses_set_updated_at
  before update on public.document_analyses
  for each row execute function public.set_updated_at();
