#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"
echo "=============================================================="
echo " WOOK V4 // 1992 \$3M CART TEAM // COMMAND -> PROOF"
echo "=============================================================="
bash scripts/doctor.sh
NATIVE=FAIL
if bash scripts/build-native.sh; then NATIVE=PASS; else echo "GB_STUDIO_NATIVE=FAIL (proof remains red)"; fi
bash scripts/deploy-github.sh
# GitHack needs GitHub push before probe.
VERCEL=FAIL
if bash scripts/deploy-vercel.sh; then VERCEL=PASS; else echo "VERCEL=FAIL_OR_AUTH"; fi
CLOUDFLARE=FAIL
if bash scripts/deploy-cloudflare.sh; then CLOUDFLARE=PASS; else echo "CLOUDFLARE=FAIL_OR_AUTH"; fi
bash scripts/prove-all.sh
git add -A
git commit -m "proof: WOOK V4 Cart Team $(date -u +%Y%m%dT%H%M%SZ)" || true
git push origin main || true
echo "NATIVE=$NATIVE VERCEL=$VERCEL CLOUDFLARE=$CLOUDFLARE"
