#!/usr/bin/env bash
#
# Deploys the portal to Cloudflare Pages.
#
# Requires wrangler authenticated (`wrangler login`) and CLOUDFLARE_ACCOUNT_ID
# available (either exported or configured via `wrangler whoami`).
#
# Usage:
#   ./scripts/deploy.sh                  # preview deploy
#   BRANCH=main ./scripts/deploy.sh      # production deploy

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

BRANCH="${BRANCH:-preview}"
PROJECT="health2u-portal"

echo "==> deploying portal to Cloudflare Pages (project=${PROJECT}, branch=${BRANCH})"

# On the very first deploy, wrangler will offer to create the Pages project
# automatically. Accept the prompt. On subsequent deploys it's a no-op.
wrangler pages deploy . \
  --project-name "${PROJECT}" \
  --branch "${BRANCH}" \
  --commit-dirty=true
