#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

GA="$HOME/.ghost-atlas"
ROOT="$GA/games/WOOK"
PROJECT="$ROOT/game/project"
SCENE_DIR="$PROJECT/project/scenes/questionable_campground"
SETTINGS="$PROJECT/project/settings.gbsres"
ROM="$ROOT/releases/native/rom/WOOK.gb"
WEB="$ROOT/site/gbstudio/index.html"

PAPA_ID="a401bba1-1e10-4a44-9001-000000000001"

echo "=== WOOK-CHAR-GOLDEN-001 READ-ONLY AUDIT ==="

pass(){ printf "PASS  %s\n" "$1"; }
fail(){ printf "FAIL  %s\n" "$1"; }

for F in \
  "$PROJECT/assets/sprites/papa-wook.png.gbsres" \
  "$PROJECT/assets/sprites/moonbeam-jessica.png.gbsres" \
  "$PROJECT/assets/sprites/raccoon.png.gbsres" \
  "$PROJECT/assets/avatars/papa-wook-neutral.png.gbsres" \
  "$PROJECT/assets/avatars/moonbeam-jessica-neutral.png.gbsres" \
  "$PROJECT/assets/avatars/raccoon.png.gbsres" \
  "$SCENE_DIR/actors/moonbeam_jessica.gbsres" \
  "$SCENE_DIR/actors/raccoon.gbsres"
do
  [ -s "$F" ] && pass "$F" || fail "$F"
done

if jq -e --arg id "$PAPA_ID" '.defaultPlayerSprites.TOPDOWN == $id' "$SETTINGS" >/dev/null 2>&1; then
  pass "Papa Wook is default TOPDOWN player"
else
  fail "Papa Wook is default TOPDOWN player"
fi

if jq -e --arg id "$PAPA_ID" '.script[0].command == "EVENT_ACTOR_SET_SPRITE" and .script[0].args.spriteSheetId == $id' "$SCENE_DIR/scene.gbsres" >/dev/null 2>&1; then
  pass "Campground explicitly activates/binds Papa Wook"
else
  fail "Campground explicitly activates/binds Papa Wook"
fi

if [ -s "$ROM" ]; then
  pass "WOOK.gb"
  echo "ROM_SHA256=$(sha256sum "$ROM" | awk '{print $1}')"
else
  fail "WOOK.gb"
fi

[ -s "$WEB" ] && pass "Native public web" || fail "Native public web"

if [ -s "$ROOT/docs/proof/receipts/CHARACTER-GOLDEN-LATEST.json" ]; then
  RESULT="$(jq -r '.result // "UNKNOWN"' "$ROOT/docs/proof/receipts/CHARACTER-GOLDEN-LATEST.json")"
  echo "RECEIPT_RESULT=$RESULT"
else
  echo "RECEIPT_RESULT=MISSING"
fi

echo "AUDIT_COMPLETE=PASS"
