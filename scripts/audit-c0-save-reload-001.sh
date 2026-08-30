#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel)"
PROJECT="$ROOT/game/project"
SETTINGS="$PROJECT/project/settings.gbsres"
ACTOR="$PROJECT/project/scenes/questionable_campground/actors/campfire_checkpoint.gbsres"
MANIFEST="$ROOT/docs/proof/C0-SAVE-RELOAD-MANIFEST.json"
fail=0
for f in \
  "$ROOT/design/production/WOOK-C0-SAVE-RELOAD-001.md" \
  "$ROOT/tools/build-c0-save-reload.py" \
  "$SETTINGS" \
  "$ACTOR" \
  "$MANIFEST"
do
  if [ -s "$f" ]; then echo "PASS=$f"; else echo "FAIL=$f"; fail=1; fi
done
jq -e '.batterylessEnabled == false' "$SETTINGS" >/dev/null || { echo "BATTERY_PATH=FAIL"; fail=1; }
jq -e '.cartType=="mbc5" or .cartType=="mbc3"' "$SETTINGS" >/dev/null || { echo "CART_TYPE=FAIL"; fail=1; }
for e in EVENT_SAVE_DATA EVENT_LOAD_DATA EVENT_IF_SAVED_DATA; do
  grep -q "$e" "$ACTOR" || { echo "$e=FAIL"; fail=1; }
done
python - <<'PY' || fail=1
import ast
from pathlib import Path
p=Path('tools/build-c0-save-reload.py')
ast.parse(p.read_text(),filename=str(p))
print('PYTHON_SYNTAX=PASS')
PY
[ "$fail" -eq 0 ] || { echo "C0_SAVE_RELOAD_AUDIT=FAIL"; exit 20; }
echo "BATTERY_BACKED_SAVE_PATH=PASS"
echo "SAVE_LOAD_EVENT_GRAPH=PASS"
echo "C0_SAVE_RELOAD_AUDIT=PASS"
