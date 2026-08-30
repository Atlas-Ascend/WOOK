#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel)"
PROJECT="$ROOT/game/project"
VARS="$PROJECT/project/variables.gbsres"
CAMP="$PROJECT/project/scenes/questionable_campground/scene.gbsres"
MANIFEST="$ROOT/docs/proof/C0-HUD-MENU-MANIFEST.json"

fail=0
required=(
  "$VARS"
  "$CAMP"
  "$PROJECT/project/scripts/wook/ui/init_wook_ui.gbsres"
  "$PROJECT/project/scripts/wook/ui/refresh_wook_hud.gbsres"
  "$PROJECT/project/scenes/ui/wook_menu/scene.gbsres"
  "$PROJECT/project/scenes/ui/wook_phone/scene.gbsres"
  "$PROJECT/project/scenes/ui/wook_inventory/scene.gbsres"
  "$PROJECT/project/scenes/ui/wook_quest/scene.gbsres"
  "$PROJECT/assets/backgrounds/wook-ui-menu.png.gbsres"
  "$PROJECT/assets/backgrounds/wook-ui-phone.png.gbsres"
  "$PROJECT/assets/backgrounds/wook-ui-inventory.png.gbsres"
  "$PROJECT/assets/backgrounds/wook-ui-quest.png.gbsres"
  "$MANIFEST"
)
for f in "${required[@]}"; do
  if [ -s "$f" ]; then
    case "$f" in *.gbsres|*.json) jq empty "$f" ;; esac
    echo "PASS=$f"
  else
    echo "MISSING=$f"
    fail=1
  fi
done

for id in 90 91 92 93 94 95 96 97; do
  jq -e --arg id "$id" '.variables[] | select(.id == $id)' "$VARS" >/dev/null || { echo "DISPLAY_VAR_FAIL=$id"; fail=1; }
done

jq -e '.script[] | select(.command == "EVENT_CALL_CUSTOM_EVENT" and .args.__name == "Init WOOK UI")' "$CAMP" >/dev/null || { echo "CAMP_UI_BINDING=FAIL"; fail=1; }

INIT="$PROJECT/project/scripts/wook/ui/init_wook_ui.gbsres"
jq -e '.script[] | select(.command == "EVENT_SET_INPUT_SCRIPT" and (.args.input | index("start")))' "$INIT" >/dev/null || { echo "START_ROUTE=FAIL"; fail=1; }
jq -e '.script[] | select(.command == "EVENT_SET_INPUT_SCRIPT" and (.args.input | index("select")))' "$INIT" >/dev/null || { echo "SELECT_ROUTE=FAIL"; fail=1; }
jq -e '.script[] | select(.command == "EVENT_CALL_CUSTOM_EVENT" and .args.__name == "Refresh HUD")' "$INIT" >/dev/null || { echo "HUD_REFRESH_BINDING=FAIL"; fail=1; }

if [ "$fail" -ne 0 ]; then
  echo "C0_HUD_MENU_AUDIT=FAIL"
  exit 20
fi

echo "DISPLAY_VARIABLES=PASS"
echo "HUD_EVENT=PASS"
echo "START_INPUT_ROUTE=PASS"
echo "SELECT_PHONE_ROUTE=PASS"
echo "MENU_SCENE=PASS"
echo "PHONE_SCENE=PASS"
echo "INVENTORY_SCENE=PASS"
echo "QUEST_LOG_SCENE=PASS"
echo "C0_HUD_MENU_AUDIT=PASS"
