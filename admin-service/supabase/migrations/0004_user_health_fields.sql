-- Add health-related fields to users table
alter table public.users add column if not exists gender text;
alter table public.users add column if not exists height_cm numeric;
alter table public.users add column if not exists weight_kg numeric;
alter table public.users add column if not exists blood_type text;
