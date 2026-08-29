#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
npm install --silent
if ! npx wrangler whoami >/dev/null 2>&1; then
  echo CLOUDFLARE_AUTH_REQUIRED
  npx wrangler login
fi
OUT="$(npx wrangler deploy --config wrangler.jsonc 2>&1 | tee /dev/stderr)"
URL="$(printf "%s\n" "$OUT" | grep -Eo "https://[^ ]+\\.workers\\.dev" | tail -1 || true)"
test -n "$URL"
printf "%s" "$URL" > "$ROOT/docs/proof/cloudflare-url.txt"
echo "CLOUDFLARE_PASS=$URL"
