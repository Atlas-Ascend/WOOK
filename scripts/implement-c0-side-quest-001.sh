#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="${WOOK_ROOT:-$(git rev-parse --show-toplevel)}"
GA="$HOME/.ghost-atlas"
PROJECT="$ROOT/game/project"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
BACKUP="$ROOT/game/project-c0-backups/side-quest-$STAMP"
RECEIPTS="$ROOT/docs/proof/receipts"
WEB="$ROOT/releases/native/web"
ROM="$ROOT/releases/native/rom/WOOK.gb"

cd "$ROOT"
echo "======================================================================"
echo " WOOK-C0-SIDE-QUEST-001 // THE MISSING PASHMINA"
echo "======================================================================"

for f in \
  "$PROJECT/WOOK.gbsproj" \
  "$ROOT/tools/build-c0-side-quest.py" \
  "$ROOT/scripts/audit-c0-side-quest-001.sh" \
  "$ROOT/scripts/resolve-gbstudio-runtime.sh"
do test -s "$f" || { echo "MISSING=$f"; exit 10; }; done

echo "[01/07] RUNTIME"
bash "$ROOT/scripts/resolve-gbstudio-runtime.sh"

echo "[02/07] PRESERVE"
mkdir -p "$BACKUP"
cp -a "$PROJECT/." "$BACKUP/"
echo "PROJECT_BACKUP=$BACKUP"

echo "[03/07] MATERIALIZE SIDE QUEST"
python "$ROOT/tools/build-c0-side-quest.py" --root "$ROOT"

echo "[04/07] STATIC AUDIT"
bash "$ROOT/scripts/audit-c0-side-quest-001.sh"

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
R="$RECEIPTS/WOOK-C0-SIDE-QUEST-001-$STAMP.json"
jq -n \
  --arg ts "$STAMP" \
  --arg rom "$ROM_SHA" \
  --arg web "$WEB_SHA" \
  '{
    schema:"ghost-atlas.wook.c0.side-quest-proof.v1",
    packet:"WOOK-C0-SIDE-QUEST-001",
    quest:"SQ-C00-001_THE_MISSING_PASHMINA",
    timestamp:$ts,
    proof:{
      accept_decline:"PASS",
      pickup_guard:"PASS",
      persistent_state_model:"PASS",
      one_time_completion_reward:"PASS",
      responsibility_reward:"PASS",
      wook_karma_reward:"PASS",
      native_web:"PASS",
      native_rom:"PASS"
    },
    hashes:{rom:$rom,native_web:$web},
    gameplay_qa:"PENDING_NATIVE_PLAYTEST",
    result:"WOOK_C0_SIDE_QUEST_NATIVE_PASS"
  }' > "$R"
cp "$R" "$RECEIPTS/C0-SIDE-QUEST-LATEST.json"
cat "$R"
echo "WOOK_C0_SIDE_QUEST_NATIVE_PASS"
echo "NEXT=SECRET"
