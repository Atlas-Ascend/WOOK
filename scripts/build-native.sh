#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; GA="$HOME/.ghost-atlas"
PROJECT="$ROOT/game/project/WOOK.gbsproj"; OUT="$ROOT/releases/native"
test -s "$PROJECT"; jq empty "$PROJECT"
bash "$ROOT/scripts/bootstrap-gbstudio-cli.sh"
rm -rf "$OUT/web"; mkdir -p "$OUT/web" "$OUT/rom"
proot-distro login ubuntu --shared-tmp --bind "$GA:/root/.ghost-atlas" -- /bin/bash -lc '
set -Eeuo pipefail
R="/root/.ghost-atlas/games/WOOK"
P="$R/game/project/WOOK.gbsproj"
O="$R/releases/native"
gb-studio-cli make:web "$P" "$O/web"
gb-studio-cli make:rom "$P" "$O/rom/WOOK.gb"
test -s "$O/web/index.html"
test -s "$O/rom/WOOK.gb"
echo GB_STUDIO_NATIVE_BUILD=PASS
'
rm -rf "$ROOT/site/gbstudio"; mkdir -p "$ROOT/site/gbstudio"
cp -a "$OUT/web"/. "$ROOT/site/gbstudio"/
echo NATIVE_PUBLICATION_PAYLOAD=PASS
