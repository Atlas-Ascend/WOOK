#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel)"
PROJECT="$ROOT/game/project"
TRIGGER="$PROJECT/project/scenes/questionable_campground/triggers/ga_exit.gbsres"
SCENE="$PROJECT/project/scenes/ga_main_lane_entry/scene.gbsres"
BG="$PROJECT/assets/backgrounds/ga-main-lane-entry.png.gbsres"
MANIFEST="$ROOT/docs/proof/C0-GA-EXIT-MANIFEST.json"
fail=0
for f in \
 "$ROOT/design/production/WOOK-C0-GA-EXIT-001.md" \
 "$ROOT/tools/build-c0-ga-exit.py" \
 "$TRIGGER" "$SCENE" "$BG" "$MANIFEST"
do if [ -s "$f" ]; then echo "PASS=$f"; else echo "FAIL=$f"; fail=1; fi; done
grep -q 'EVENT_IF_VALUE' "$TRIGGER" || { echo "CROCS_GATE=FAIL"; fail=1; }
grep -q 'EVENT_SWITCH_SCENE' "$TRIGGER" || { echo "SCENE_SWITCH=FAIL"; fail=1; }
grep -q 'barefoot' "$TRIGGER" || { echo "BLOCKED_FEEDBACK=FAIL"; fail=1; }
jq -e '.target_truth=="C01_ENTRY_SEAM_ONLY" and .c01_qualified==false' "$MANIFEST" >/dev/null || { echo "C01_TRUTH=FAIL"; fail=1; }
python - <<'PY' || fail=1
import ast
from pathlib import Path
p=Path('tools/build-c0-ga-exit.py'); ast.parse(p.read_text(),filename=str(p)); print('PYTHON_SYNTAX=PASS')
PY
[ "$fail" -eq 0 ] || { echo "C0_GA_EXIT_AUDIT=FAIL"; exit 20; }
echo "C0_GA_EXIT_CROCS_GATE=PASS"
echo "C0_GA_EXIT_TARGET_SCENE=PASS"
echo "C01_FALSE_COMPLETION_GUARD=PASS"
echo "C0_GA_EXIT_AUDIT=PASS"
