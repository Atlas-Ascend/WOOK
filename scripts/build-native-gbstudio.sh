#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GA="$HOME/.ghost-atlas"
PROJECT="$ROOT/game/project/WOOK.gbsproj"
OUT="$ROOT/releases/native"
mkdir -p "$OUT/web"

test -s "$PROJECT" || { echo "GB_STUDIO_SOURCE=FAIL"; exit 20; }
jq empty "$PROJECT"
echo "GB_STUDIO_SOURCE=PASS"

# Find or build CLI in Ubuntu.
proot-distro login ubuntu --shared-tmp --bind "$GA:/root/.ghost-atlas" -- /bin/bash -s <<'INNER'
set -Eeuo pipefail
ROOT="/root/.ghost-atlas/games/WOOK"
PROJECT="$ROOT/game/project/WOOK.gbsproj"
OUT="$ROOT/releases/native"
CLI="$(command -v gb-studio-cli 2>/dev/null || true)"
if [ -z "$CLI" ]; then
  CLI="$(find /usr /opt -type f -name gb-studio-cli -perm -111 2>/dev/null | head -1 || true)"
fi
if [ -z "$CLI" ]; then
  echo "GB_STUDIO_CLI=NOT_FOUND"
  exit 21
fi
rm -rf "$OUT/web"; mkdir -p "$OUT/web"
"$CLI" make:web "$PROJECT" "$OUT/web"
"$CLI" make:rom "$PROJECT" "$OUT/WOOK.gb"
test -s "$OUT/web/index.html"
test -s "$OUT/WOOK.gb"
echo "GB_STUDIO_BUILD=PASS"
INNER
