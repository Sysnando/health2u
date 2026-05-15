-- Create storage buckets for exam files and profile photos.
-- Using Supabase Storage instead of Cloudflare R2 to avoid S3 TLS issues.

INSERT INTO storage.buckets (id, name, public)
VALUES ('exam-files', 'exam-files', false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public)
VALUES ('profile-photos', 'profile-photos', false)
ON CONFLICT (id) DO NOTHING;
