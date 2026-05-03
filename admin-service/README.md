# admin-service

REST API for the Health2U mobile app, deployed as a **Supabase Edge
Function** (Deno + Hono) backed by **Supabase Postgres** for data and
**Cloudflare R2** for exam-file storage.

## Stack

| Concern | Service |
| --- | --- |
| API runtime | Supabase Edge Functions (Deno) |
| Routing | Hono |
| Database | Supabase Postgres |
| Auth | Custom JWT (our own `/auth/login`; Supabase Auth not used) |
| File storage | Cloudflare R2 (presigned PUT/GET URLs) |

## Layout

```
admin-service/
├── supabase/
│   ├── config.toml
│   ├── migrations/               # SQL schema + seed
│   └── functions/
│       ├── deno.json             # import map (hono, sdk, jwt, bcrypt, aws-sdk)
│       ├── _shared/              # db, jwt, auth middleware, r2, dto, errors
│       └── admin/
│           ├── index.ts          # Hono entry (Deno.serve)
│           └── routes/           # auth, user, exams, appointments, insights, …
├── scripts/
│   ├── create-r2-bucket.sh
│   └── deploy.sh
├── .env.example
└── README.md
```

## One-time setup

1. **Install CLIs**
   - [Supabase CLI](https://supabase.com/docs/guides/cli) (`brew install supabase/tap/supabase`)
   - [wrangler](https://developers.cloudflare.com/workers/wrangler/install-and-update/) (`npm i -g wrangler`)
   - `deno` (optional, only for local type-checking)

2. **Create + link the Supabase project**
   ```bash
   # From the Supabase dashboard, create a new project, then:
   supabase link --project-ref <your-project-ref>
   ```

3. **Create the R2 bucket**
   ```bash
   wrangler login
   BUCKET=health2u-admin-dev-uploads ./scripts/create-r2-bucket.sh
   ```
   In the Cloudflare dashboard, create an R2 API token scoped to that bucket
   with **Object Read & Write**. Copy the Access Key ID / Secret.

4. **Fill in `.env`**
   ```bash
   cp .env.example .env
   # Generate JWT_SECRET:   openssl rand -hex 32
   # Paste R2 credentials from the previous step.
   ```

## Deploying

```bash
./scripts/deploy.sh
```

This runs `supabase db push`, uploads the `.env` as function secrets, and
deploys the `admin` function. The public URL is:

```
https://<project_ref>.supabase.co/functions/v1/admin
```

Quick check:

```bash
curl https://<project_ref>.supabase.co/functions/v1/admin/health
# {"status":"ok"}
```

## Staging deployment

1. Create a second Supabase project (free tier is fine) and note its project ref.
2. Optionally create a staging R2 bucket:
   ```bash
   BUCKET=health2u-admin-staging-uploads ./scripts/create-r2-bucket.sh
   ```
3. Fill in `.env.staging`:
   ```bash
   cp .env.staging.example .env.staging
   # Set STAGING_PROJECT_REF, JWT_SECRET (different from prod!), R2 creds, etc.
   ```
4. Deploy:
   ```bash
   ./scripts/deploy-staging.sh
   ```
   Staging URL: `https://<staging-ref>.supabase.co/functions/v1/admin/health`

## API

All routes are nested under `/admin`. The `/auth/*` routes and `/health`
are public; everything else requires `Authorization: Bearer <access_token>`.

| Method | Path | Notes |
| --- | --- | --- |
| GET | `/health` | Liveness |
| POST | `/auth/login` | `{ email, password }` → `{ access_token, refresh_token, user }` |
| POST | `/auth/refresh` | One-time-use: old refresh token is deleted |
| POST | `/auth/logout` | Invalidates the refresh token |
| GET | `/user/profile` | |
| PUT | `/user/profile` | |
| GET | `/exams?filter=<type>` | |
| GET | `/exams/:id` | |
| GET | `/exams/:id/file` | Returns `{ url }` — 5-minute presigned R2 GET |
| POST | `/exams/upload-url` | `{ filename, content_type }` → presigned R2 PUT |
| POST | `/exams` | `{ title, type, date, notes?, key? }` — metadata-only |
| DELETE | `/exams/:id` | |
| GET | `/appointments` | |
| POST | `/appointments` | |
| PUT | `/appointments/:id` | |
| DELETE | `/appointments/:id` | |
| GET | `/insights` | Wrapped as `{ insights: [...] }` |
| GET | `/emergency-contacts` | |
| POST | `/emergency-contacts` | |
| PUT | `/emergency-contacts/:id` | |
| DELETE | `/emergency-contacts/:id` | |

### Upload flow (replaces old multipart `/exams/upload`)

```
1. POST /exams/upload-url   { filename, content_type }
      → { upload_url, key, expires_in }
2. PUT <upload_url>          <raw file bytes>   (direct to R2)
3. POST /exams               { title, type, date, notes, key }
      → exam record
```

Uploads never flow through the Edge Function, so there's no body-size
bottleneck.

### Demo credentials

Seeded by `migrations/0002_seed.sql`:
- `sarah@example.com` / `password123`

## Local development

```bash
# Requires Docker Desktop (Supabase CLI runs Postgres + functions locally).
supabase start                           # boots local stack
supabase functions serve admin --env-file .env --no-verify-jwt
# → http://localhost:54321/functions/v1/admin/health
```

Migrations in `supabase/migrations/` are applied automatically when you run
`supabase db reset`.
