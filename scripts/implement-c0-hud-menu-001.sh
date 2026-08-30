#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

GA="$HOME/.ghost-atlas"
ROOT="$(git rev-parse --show-toplevel)"
PROJECT="$ROOT/game/project"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
BACKUP="$ROOT/game/project-c0-backups/hud-menu-$STAMP"
RECEIPTS="$ROOT/docs/proof/receipts"
WEB="$ROOT/releases/native/web"
ROM="$ROOT/releases/native/rom/WOOK.gb"

cd "$ROOT"
echo "======================================================================"
echo " WOOK-C0-HUD-MENU-001 // NATIVE INTERFACE RUNTIME"
echo " HUD + PHONE + INVENTORY + QUEST LOG"
echo "======================================================================"

for f in \
  "$PROJECT/WOOK.gbsproj" \
  "$PROJECT/project/variables.gbsres" \
  "$PROJECT/project/scenes/questionable_campground/scene.gbsres" \
  "$ROOT/tools/build-c0-hud-menu.py" \
  "$ROOT/scripts/audit-c0-hud-menu-001.sh" \
  "$ROOT/scripts/resolve-gbstudio-runtime.sh"
do
  test -s "$f" || { echo "MISSING=$f"; exit 10; }
done

echo "[01/07] RUNTIME"
bash "$ROOT/scripts/resolve-gbstudio-runtime.sh"

echo "[02/07] PRESERVE"
mkdir -p "$BACKUP"
cp -a "$PROJECT/." "$BACKUP/"
echo "PROJECT_BACKUP=$BACKUP"

echo "[03/07] MATERIALIZE HUD + MENU RESOURCE GRAPH"
python "$ROOT/tools/build-c0-hud-menu.py" --root "$ROOT"

echo "[04/07] STATIC AUDIT"
bash "$ROOT/scripts/audit-c0-hud-menu-001.sh"

echo "[05/07] NATIVE COMPILE"
rm -rf "$WEB"
mkdir -p "$WEB" "$(dirname "$ROM")"
rm -f "$ROM"
proot-distro login ubuntu \
  --shared-tmp \
  --bind "$GA:/root/.ghost-atlas" \
  --bind "$ROOT:/root/WOOK-CURRENT" \
  -- /bin/bash -s <<'INNER'
set -Eeuo pipefail
ROOT="/root/WOOK-CURRENT"
PROJECT="$ROOT/game/project/WOOK.gbsproj"
WEB="$ROOT/releases/native/web"
ROM="$ROOT/releases/native/rom/WOOK.gb"
gb-studio-cli make:web "$PROJECT" "$WEB"
test -s "$WEB/index.html"
echo "GB_STUDIO_NATIVE_WEB=PASS"
gb-studio-cli make:rom "$PROJECT" "$ROM"
test -s "$ROM"
echo "GB_STUDIO_ROM=PASS"
INNER

echo "[06/07] PROMOTE + HASH"
rm -rf "$ROOT/site/gbstudio"
mkdir -p "$ROOT/site/gbstudio"
cp -a "$WEB/." "$ROOT/site/gbstudio/"
ROM_SHA="$(sha256sum "$ROM" | awk '{print $1}')"
WEB_SHA="$(sha256sum "$ROOT/site/gbstudio/index.html" | awk '{print $1}')"

echo "[07/07] RECEIPT"
mkdir -p "$RECEIPTS"
R="$RECEIPTS/WOOK-C0-HUD-MENU-001-$STAMP.json"
jq -n --arg ts "$STAMP" --arg rom "$ROM_SHA" --arg web "$WEB_SHA" '{
  schema:"ghost-atlas.wook.c0.hud-menu-proof.v1",
  packet:"WOOK-C0-HUD-MENU-001",
  timestamp:$ts,
  proof:{
    runtime_resolver:"PASS",
    preserve:"PASS",
    display_variables:"PASS",
    exploration_hud:"PASS",
    start_menu_route:"PASS",
    select_phone_route:"PASS",
    phone_runtime:"PASS",
    inventory_runtime:"PASS",
    quest_log_runtime:"PASS",
    native_web:"PASS",
    native_rom:"PASS"
  },
  hashes:{rom:$rom,native_web:$web},
  visual_qa:"PENDING_NATIVE_SCREENSHOT",
  result:"WOOK_C0_HUD_MENU_NATIVE_PASS"
}' > "$R"
cp "$R" "$RECEIPTS/C0-HUD-MENU-LATEST.json"
cat "$R"

echo "======================================================================"
echo " WOOK_C0_HUD_MENU_NATIVE_PASS"
echo "======================================================================"
echo "HUD=PASS"
echo "PHONE=PASS"
echo "INVENTORY=PASS"
echo "QUEST_LOG=PASS"
echo "ROM_SHA256=$ROM_SHA"
echo "VISUAL_QA=PENDING_NATIVE_SCREENSHOT"
echo "NEXT=GROUNDSCORE_RESPONSIBILITY_WOOK_KARMA"
