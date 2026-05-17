-- Add language column to document_analyses so we can preserve the detected
-- language of the source document (ISO 639-1 code, e.g. en, pt, es, fr).
alter table public.document_analyses add column language text;
