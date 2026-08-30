#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${WOOK_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
PROJECT="$ROOT/game/project"
SCENE_DIR="$PROJECT/project/scenes/questionable_campground"
SETTINGS="$PROJECT/project/settings.gbsres"
ROM="$ROOT/releases/native/rom/WOOK.gb"
WEB="$ROOT/site/gbstudio/index.html"
PAPA_ID="a401bba1-1e10-4a44-9001-000000000001"

cd "$ROOT"
echo "=== WOOK-CHAR-GOLDEN-001 READ-ONLY CANONICAL AUDIT ==="
echo "ACTIVE_ROOT=$ROOT"

fail=0
pass(){ printf "PASS  %s\n" "$1"; }
miss(){ printf "FAIL  %s\n" "$1"; fail=1; }

for F in \
  "$PROJECT/assets/sprites/papa-wook.png.gbsres" \
  "$PROJECT/assets/sprites/sniffany.png.gbsres" \
  "$PROJECT/assets/sprites/raccoon.png.gbsres" \
  "$PROJECT/assets/avatars/papa-wook-neutral.png.gbsres" \
  "$PROJECT/assets/avatars/sniffany-neutral.png.gbsres" \
  "$PROJECT/assets/avatars/raccoon.png.gbsres" \
  "$SCENE_DIR/actors/sniffany.gbsres" \
  "$SCENE_DIR/actors/raccoon.gbsres"
do
  [ -s "$F" ] && pass "$F" || miss "$F"
done

if jq -e --arg id "$PAPA_ID" '.defaultPlayerSprites.TOPDOWN == $id' "$SETTINGS" >/dev/null 2>&1; then
  pass "Papa Wook is default TOPDOWN player"
else
  miss "Papa Wook is default TOPDOWN player"
fi

if jq -e --arg id "$PAPA_ID" '.script[0].command == "EVENT_ACTOR_SET_SPRITE" and .script[0].args.spriteSheetId == $id' "$SCENE_DIR/scene.gbsres" >/dev/null 2>&1; then
  pass "Campground explicitly activates/binds Papa Wook"
else
  miss "Campground explicitly activates/binds Papa Wook"
fi

# Deprecated active runtime identities are forbidden. Legacy backup/provenance
# directories are intentionally outside this audit.
for old in \
  "$PROJECT/assets/sprites/moonbeam-jessica.png.gbsres" \
  "$PROJECT/assets/avatars/moonbeam-jessica-neutral.png.gbsres" \
  "$SCENE_DIR/actors/moonbeam_jessica.gbsres"
do
  if [ -e "$old" ]; then
    miss "deprecated active resource exists: $old"
  else
    pass "deprecated active resource absent: $old"
  fi
done

if [ -s "$ROM" ]; then
  pass "WOOK.gb"
  echo "ROM_SHA256=$(sha256sum "$ROM" | awk '{print $1}')"
else
  miss "WOOK.gb"
fi

[ -s "$WEB" ] && pass "Native public web" || miss "Native public web"

R="$ROOT/docs/proof/receipts/CHARACTER-GOLDEN-LATEST.json"
if [ -s "$R" ]; then
  RESULT="$(jq -r '.result // "UNKNOWN"' "$R")"
  echo "RECEIPT_RESULT=$RESULT"
  [ "$RESULT" = "WOOK_CHAR_GOLDEN_NATIVE_PASS" ] || miss "character receipt result"
else
  miss "character receipt"
fi

if [ "$fail" -ne 0 ]; then
  echo "WOOK_CHARACTER_GOLDEN_AUDIT=FAIL"
  exit 20
fi

echo "WOOK_CHARACTER_GOLDEN_AUDIT=PASS"
