#!/usr/bin/env bash
#
# Deploys schema migrations and the `admin` Edge Function to the STAGING
# Supabase project.
#
# Requires:
#   - STAGING_PROJECT_REF env var (or set it in .env.staging)
#   - .env.staging file with staging secrets
#
# Usage:
#   ./scripts/deploy-staging.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

ENV_FILE=".env.staging"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "error: ${ENV_FILE} not found. Copy .env.staging.example to ${ENV_FILE} and fill it in."
  exit 1
fi

# Read STAGING_PROJECT_REF from the env file if not already exported
if [[ -z "${STAGING_PROJECT_REF:-}" ]]; then
  STAGING_PROJECT_REF="$(grep -E '^STAGING_PROJECT_REF=' "${ENV_FILE}" | cut -d= -f2-)"
fi

if [[ -z "${STAGING_PROJECT_REF:-}" ]]; then
  echo "error: STAGING_PROJECT_REF is not set. Add it to ${ENV_FILE} or export it."
  exit 1
fi

echo "==> linking to staging project: ${STAGING_PROJECT_REF}"
supabase link --project-ref "${STAGING_PROJECT_REF}"

echo "==> pushing DB migrations"
supabase db push

echo "==> uploading function secrets"
# Strip the STAGING_PROJECT_REF line — it's not a function secret.
grep -v '^STAGING_PROJECT_REF=' "${ENV_FILE}" | grep -v '^#' | grep -v '^$' > /tmp/staging-secrets.env
supabase secrets set --env-file /tmp/staging-secrets.env
rm -f /tmp/staging-secrets.env

echo "==> deploying admin function"
supabase functions deploy admin --no-verify-jwt

echo ""
echo "Done. Staging URL:"
echo "  https://${STAGING_PROJECT_REF}.supabase.co/functions/v1/admin/health"
