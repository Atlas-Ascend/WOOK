#!/data/data/com.termux/files/usr/bin/bash
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "=== WOOK V4 DOCTOR ==="
for f in \
 art/reference/WOOK-VISUAL-CONTRACT-LEVEL10-BOARD-A.png \
 art/reference/WOOK-VISUAL-CONTRACT-LEVEL10-BOARD-B.png \
 game/project/WOOK.gbsproj \
 game/assets/backgrounds/act1-golden-campground.png \
 game/assets/sprites/papa-wook.png \
 game/assets/avatars/papa-wook-neutral.png \
 game/assets/ui/title-screen.png \
 site/golden/index.html \
 site/index.html \
 wrangler.jsonc \
 vercel.json; do
 [ -s "$ROOT/$f" ] && echo "PASS $f" || echo "FAIL $f"
done
jq empty "$ROOT/game/project/WOOK.gbsproj" && echo "PASS gbsproj-json"
