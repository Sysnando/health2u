#!/usr/bin/env bash
#
# Creates the Cloudflare R2 bucket used for exam uploads.
# Requires:
#   - wrangler CLI authenticated (`wrangler login`)
#   - CLOUDFLARE_ACCOUNT_ID exported or set in wrangler config
#
# Usage:
#   BUCKET=health2u-admin-dev-uploads ./scripts/create-r2-bucket.sh

set -euo pipefail

BUCKET="${BUCKET:-health2u-admin-dev-uploads}"

echo "==> creating R2 bucket: ${BUCKET}"
wrangler r2 bucket create "${BUCKET}"

echo ""
echo "Next steps:"
echo "  1. In the Cloudflare dashboard → R2 → Manage R2 API Tokens,"
echo "     create a token scoped to this bucket with Object Read+Write."
echo "  2. Put the Access Key ID and Secret into .env as"
echo "     R2_ACCESS_KEY_ID / R2_SECRET_ACCESS_KEY."
echo "  3. Set R2_ACCOUNT_ID and R2_BUCKET=${BUCKET} in .env."
echo "  4. Run: supabase secrets set --env-file .env"
