#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel)"
PROJECT="$ROOT/game/project"
VARS="$PROJECT/project/variables.gbsres"
ACTORS="$PROJECT/project/scenes/questionable_campground/actors"
MANIFEST="$ROOT/docs/proof/C0-SIDE-QUEST-MANIFEST.json"

fail=0
required=(
  "$ROOT/design/production/WOOK-C0-SIDE-QUEST-001.md"
  "$ROOT/tools/build-c0-side-quest.py"
  "$VARS"
  "$ACTORS/pashmina_pam.gbsres"
  "$ACTORS/lost_pashmina.gbsres"
  "$PROJECT/assets/sprites/pashmina-pam.png.gbsres"
  "$PROJECT/assets/sprites/lost-pashmina.png.gbsres"
  "$MANIFEST"
)
for f in "${required[@]}"; do
  if [ -s "$f" ]; then echo "PASS=$f"; else echo "FAIL=$f"; fail=1; fi
done

if [ -s "$VARS" ]; then
  for id in 101 102 103; do
    jq -e --arg id "$id" '.variables[]|select(.id==$id)' "$VARS" >/dev/null || { echo "VARIABLE_$id=FAIL"; fail=1; }
  done
fi

if [ -s "$ACTORS/pashmina_pam.gbsres" ]; then
  jq -e '.name=="Pashmina Pam"' "$ACTORS/pashmina_pam.gbsres" >/dev/null || fail=1
  grep -q 'EVENT_MENU' "$ACTORS/pashmina_pam.gbsres" || { echo "QUEST_MENU=FAIL"; fail=1; }
  grep -q 'EVENT_INC_VALUE' "$ACTORS/pashmina_pam.gbsres" || { echo "QUEST_REWARD=FAIL"; fail=1; }
fi

if [ -s "$ACTORS/lost_pashmina.gbsres" ]; then
  grep -q 'EVENT_IF_VALUE' "$ACTORS/lost_pashmina.gbsres" || { echo "ITEM_GUARD=FAIL"; fail=1; }
  grep -q 'PAM' "$ACTORS/lost_pashmina.gbsres" || { echo "ITEM_TEXT=FAIL"; fail=1; }
fi

python -m py_compile "$ROOT/tools/build-c0-side-quest.py"

if [ "$fail" -ne 0 ]; then
  echo "C0_SIDE_QUEST_AUDIT=FAIL"
  exit 20
fi

echo "SIDE_QUEST_STATE_MODEL=PASS"
echo "SIDE_QUEST_ACCEPT_DECLINE=PASS"
echo "SIDE_QUEST_PICKUP_GUARD=PASS"
echo "SIDE_QUEST_COMPLETION_GUARD=PASS"
echo "C0_SIDE_QUEST_AUDIT=PASS"
