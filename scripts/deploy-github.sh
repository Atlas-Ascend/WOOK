#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"
git add -A
git commit -m "WOOK V4 1992 Cart Team $(date -u +%Y%m%dT%H%M%SZ)" || true
git pull --rebase origin main || true
git push origin main
L="$(git rev-parse HEAD)"; R="$(git ls-remote origin refs/heads/main | awk '{print $1}')"
test "$L" = "$R"
echo "GITHUB_PASS=$L"
