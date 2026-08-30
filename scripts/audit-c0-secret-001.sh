#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel)"
PROJECT="$ROOT/game/project"
VARS="$PROJECT/project/variables.gbsres"
ACTOR="$PROJECT/project/scenes/questionable_campground/actors/secret_ceremonial_zip_tie.gbsres"
MANIFEST="$ROOT/docs/proof/C0-SECRET-MANIFEST.json"
fail=0
for f in \
  "$ROOT/design/production/WOOK-C0-SECRET-001.md" \
  "$ROOT/tools/build-c0-secret.py" \
  "$VARS" \
  "$ACTOR" \
  "$PROJECT/assets/sprites/ceremonial-zip-tie.png.gbsres" \
  "$MANIFEST"
do
  if [ -s "$f" ]; then echo "PASS=$f"; else echo "FAIL=$f"; fail=1; fi
done
for id in 104 105; do
  jq -e --arg id "$id" '.variables[]|select(.id==$id)' "$VARS" >/dev/null || { echo "VARIABLE_$id=FAIL"; fail=1; }
done
jq -e '.item_id=="ITEM-WOOK-CEREMONIAL-ZIP-TIE"' "$MANIFEST" >/dev/null || { echo "STABLE_ITEM_ID=FAIL"; fail=1; }
grep -q 'EVENT_IF_VALUE' "$ACTOR" || { echo "ONE_TIME_GUARD=FAIL"; fail=1; }
grep -q 'EVENT_INC_VALUE' "$ACTOR" || { echo "GROUNDSCORE_REWARD=FAIL"; fail=1; }
python - <<'PY' || fail=1
import ast
from pathlib import Path
p=Path('tools/build-c0-secret.py')
ast.parse(p.read_text(),filename=str(p))
print('PYTHON_SYNTAX=PASS')
PY
[ "$fail" -eq 0 ] || { echo "C0_SECRET_AUDIT=FAIL"; exit 20; }
echo "C0_SECRET_STABLE_ID=PASS"
echo "C0_SECRET_ONE_TIME_GUARD=PASS"
echo "C0_SECRET_AUDIT=PASS"
