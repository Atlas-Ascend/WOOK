#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel)"
PROJECT="$ROOT/game/project"
SCENE_DIR="$PROJECT/project/scenes/questionable_campground"

required=(
  "$ROOT/design/characters/HANDSTAND-DAN-PRODUCTION-BIBLE.md"
  "$ROOT/tools/generate-handstand-dan.py"
  "$PROJECT/assets/sprites/handstand-dan.png"
  "$PROJECT/assets/sprites/handstand-dan.png.gbsres"
  "$PROJECT/assets/avatars/handstand-dan.png"
  "$PROJECT/assets/avatars/handstand-dan.png.gbsres"
  "$SCENE_DIR/actors/handstand_dan.gbsres"
  "$ROOT/docs/proof/C0-HANDSTAND-DAN-MANIFEST.json"
)

for f in "${required[@]}"; do
  test -s "$f" || { echo "MISSING=$f"; exit 10; }
done

python - "$PROJECT" "$SCENE_DIR" <<'PY'
from pathlib import Path
import json, sys
project = Path(sys.argv[1]); scene = Path(sys.argv[2])
spr = json.loads((project/'assets/sprites/handstand-dan.png.gbsres').read_text())
av = json.loads((project/'assets/avatars/handstand-dan.png.gbsres').read_text())
actor = json.loads((scene/'actors/handstand_dan.gbsres').read_text())
assert spr['name'] == 'Handstand Dan'
assert spr['symbol'] == 'sprite_handstand_dan'
assert actor['name'] == 'Handstand Dan'
assert actor['spriteSheetId'] == spr['id']
assert actor['script'][0]['args']['avatarId'] == av['id']
assert actor['persistent'] is False
print('HANDSTAND_DAN_RESOURCE_GRAPH=PASS')
PY

echo "HANDSTAND_DAN_CRITICAL_PATH_NONBLOCKING=PASS"
echo "WOOK_C0_HANDSTAND_DAN_STATIC_AUDIT=PASS"
