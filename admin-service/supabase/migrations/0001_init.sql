-- Health2U admin-service schema.
-- All tables are owned by the service (service-role key) and accessed via
-- the `admin` Edge Function. Row-level security is enabled as a safety net
-- so anon/authenticated keys cannot read or write directly; the service role
-- bypasses RLS by design.

create extension if not exists "pgcrypto";

-- ── users ─────────────────────────────────────────────────────────────
create table public.users (
  id                   uuid primary key default gen_random_uuid(),
  email                text not null unique,
  password_hash        text not null,
  name                 text not null,
  phone                text,
  date_of_birth        bigint,             -- epoch millis (matches mobile contract)
  profile_picture_url  text,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now()
);

-- ── refresh_tokens ────────────────────────────────────────────────────
create table public.refresh_tokens (
  token       uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.users(id) on delete cascade,
  expires_at  timestamptz not null,
  created_at  timestamptz not null default now()
);

create index refresh_tokens_user_id_idx on public.refresh_tokens(user_id);
create index refresh_tokens_expires_at_idx on public.refresh_tokens(expires_at);

-- ── exams ─────────────────────────────────────────────────────────────
create table public.exams (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.users(id) on delete cascade,
  title       text not null,
  type        text not null,
  date        bigint not null,            -- epoch millis
  file_key    text,                       -- R2 object key (null if no file)
  notes       text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index exams_user_id_idx on public.exams(user_id);
create index exams_user_type_idx on public.exams(user_id, type);

-- ── appointments ──────────────────────────────────────────────────────
create table public.appointments (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references public.users(id) on delete cascade,
  title             text not null,
  description       text,
  doctor_name       text,
  location          text,
  date_time         bigint not null,      -- epoch millis
  reminder_minutes  int,
  status            text not null default 'UPCOMING'
                    check (status in ('UPCOMING', 'COMPLETED', 'CANCELLED')),
  created_at        timestamptz not null default now()
);

create index appointments_user_id_idx on public.appointments(user_id);
create index appointments_user_date_idx on public.appointments(user_id, date_time);

-- ── insights ──────────────────────────────────────────────────────────
create table public.insights (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.users(id) on delete cascade,
  type          text not null,
  title         text not null,
  description   text not null,
  metric_value  numeric,
  timestamp     bigint not null,          -- epoch millis
  created_at    timestamptz not null default now()
);

create index insights_user_id_idx on public.insights(user_id);
create index insights_user_ts_idx on public.insights(user_id, timestamp desc);

-- ── emergency_contacts ────────────────────────────────────────────────
create table public.emergency_contacts (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.users(id) on delete cascade,
  name          text not null,
  relationship  text not null,
  phone         text not null,
  email         text,
  is_primary    boolean not null default false,
  "order"       int not null default 0,
  created_at    timestamptz not null default now()
);

create index emergency_contacts_user_id_idx on public.emergency_contacts(user_id);

-- ── RLS ───────────────────────────────────────────────────────────────
-- Turn RLS on everywhere. We never attach policies because the Edge
-- Function uses the service-role key (which bypasses RLS). This makes
-- accidental access via anon/authenticated JWTs a no-op.
alter table public.users              enable row level security;
alter table public.refresh_tokens     enable row level security;
alter table public.exams              enable row level security;
alter table public.appointments       enable row level security;
alter table public.insights           enable row level security;
alter table public.emergency_contacts enable row level security;

-- ── updated_at trigger helper ─────────────────────────────────────────
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger users_set_updated_at
  before update on public.users
  for each row execute function public.set_updated_at();

create trigger exams_set_updated_at
  before update on public.exams
  for each row execute function public.set_updated_at();
