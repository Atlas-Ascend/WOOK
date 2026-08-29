#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
npm install --silent
if ! npx vercel whoami >/dev/null 2>&1; then
  echo VERCEL_AUTH_REQUIRED
  npx vercel login
fi
npx vercel link --yes --project wook-cart-team --scope ghost-atlas || true
OUT="$(npx vercel deploy site --prod --yes --project wook-cart-team --scope ghost-atlas 2>&1 | tee /dev/stderr)"
URL="$(printf "%s\n" "$OUT" | grep -Eo "https://[^ ]+\\.vercel\\.app" | tail -1 || true)"
test -n "$URL"
printf "%s" "$URL" > "$ROOT/docs/proof/vercel-url.txt"
echo "VERCEL_PASS=$URL"
