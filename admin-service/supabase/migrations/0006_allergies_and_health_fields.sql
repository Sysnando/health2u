ALTER TABLE public.users ADD COLUMN IF NOT EXISTS has_diabetes boolean DEFAULT false;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS has_allergies boolean DEFAULT false;

CREATE TABLE IF NOT EXISTS public.allergies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  severity text,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_allergies_user_id ON public.allergies(user_id);
