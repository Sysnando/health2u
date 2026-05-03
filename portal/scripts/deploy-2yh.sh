#!/usr/bin/env bash
#
# Deploys the 2YH portal to Cloudflare Pages.
#
# Requires wrangler authenticated (`wrangler login`) and CLOUDFLARE_ACCOUNT_ID
# available (either exported or configured via `wrangler whoami`).
#
# Usage:
#   ./scripts/deploy-2yh.sh                  # preview deploy
#   BRANCH=main ./scripts/deploy-2yh.sh      # production deploy

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

BRANCH="${BRANCH:-preview}"
PROJECT="2yh-portal"

echo "==> deploying 2YH portal to Cloudflare Pages (project=${PROJECT}, branch=${BRANCH})"

# On the very first deploy, wrangler will offer to create the Pages project
# automatically. Accept the prompt. On subsequent deploys it's a no-op.
wrangler pages deploy . \
  --project-name "${PROJECT}" \
  --branch "${BRANCH}" \
  --commit-dirty=true
