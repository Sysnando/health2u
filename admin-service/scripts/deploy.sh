#!/usr/bin/env bash
#
# Deploys schema migrations and the `admin` Edge Function to the currently
# linked Supabase project (link once with `supabase link --project-ref <ref>`).
#
# Usage:
#   ./scripts/deploy.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

if [[ ! -f .env ]]; then
  echo "error: .env not found. Copy .env.example to .env and fill it in."
  exit 1
fi

echo "==> pushing DB migrations"
supabase db push

echo "==> uploading function secrets"
supabase secrets set --env-file .env

echo "==> deploying admin function"
# --no-verify-jwt: our function handles its own JWTs. config.toml already
# sets verify_jwt=false but we pass the flag explicitly for clarity.
supabase functions deploy admin --no-verify-jwt --import-map supabase/functions/deno.json

echo ""
echo "Done. The function URL has the shape:"
echo "  https://<project_ref>.supabase.co/functions/v1/admin/health"
