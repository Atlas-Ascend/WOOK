#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

GA="$HOME/.ghost-atlas"
ROOT="$(git rev-parse --show-toplevel)"
PROJECT="$ROOT/game/project"
SCENE_DIR="$PROJECT/project/scenes/questionable_campground"
SPRITES="$PROJECT/assets/sprites"
AVATARS="$PROJECT/assets/avatars"
SOURCE="$ROOT/art/source/characters/handstand-dan/exports"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"

DAN_SPRITE_ID="a401bba1-1e10-4a44-9001-000000000004"
DAN_AVATAR_ID="a401bba1-1e10-4a44-9001-000000000104"
DAN_ACTOR_ID="a401bba1-1e10-4a44-9001-000000001003"

cd "$ROOT"
echo "=== WOOK-C0-HANDSTAND-DAN-001 ==="

for f in \
  "$PROJECT/WOOK.gbsproj" \
  "$SPRITES/actor_animated.png.gbsres" \
  "$SCENE_DIR/scene.gbsres" \
  "$ROOT/tools/generate-handstand-dan.py"
do
  test -s "$f" || { echo "MISSING=$f"; exit 10; }
done

echo "BASELINE=PASS"

mkdir -p "$SOURCE" "$SPRITES" "$AVATARS" "$SCENE_DIR/actors" "$ROOT/docs/proof"
python "$ROOT/tools/generate-handstand-dan.py" \
  --sprite "$SOURCE/handstand-dan.png" \
  --avatar "$SOURCE/handstand-dan-avatar.png"

cp "$SOURCE/handstand-dan.png" "$SPRITES/handstand-dan.png"
cp "$SOURCE/handstand-dan-avatar.png" "$AVATARS/handstand-dan.png"

python - "$ROOT" "$DAN_SPRITE_ID" "$DAN_AVATAR_ID" "$DAN_ACTOR_ID" <<'PY'
from pathlib import Path
import copy, hashlib, json, sys, uuid

root = Path(sys.argv[1])
sprite_id, avatar_id, actor_id = sys.argv[2:5]
project = root / 'game/project'
sprites = project / 'assets/sprites'
avatars = project / 'assets/avatars'
scene_dir = project / 'project/scenes/questionable_campground'

NS = uuid.UUID('69f03458-f4e0-4c93-bab5-6ca12e91f4ef')
def uid(label): return str(uuid.uuid5(NS, 'WOOK-C0-HANDSTAND-DAN-001/' + label))
def sha1(p): return hashlib.sha1(p.read_bytes()).hexdigest()
def write(p, obj):
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(obj, indent=2) + '\n')

def reuuid(v, prefix):
    n = [0]
    def walk(x):
        if isinstance(x, dict):
            out = {}
            for k, val in x.items():
                if k == 'id' and isinstance(val, str):
                    n[0] += 1
                    out[k] = uid(f'{prefix}/{n[0]}')
                else:
                    out[k] = walk(val)
            return out
        if isinstance(x, list): return [walk(i) for i in x]
        return x
    return walk(v)

template = json.loads((sprites / 'actor_animated.png.gbsres').read_text())
res = reuuid(copy.deepcopy(template), 'sprite')
res['id'] = sprite_id
res['name'] = 'Handstand Dan'
res['symbol'] = 'sprite_handstand_dan'
res['filename'] = 'handstand-dan.png'
res['width'] = 96
res['height'] = 16
res['checksum'] = sha1(sprites / 'handstand-dan.png')
write(sprites / 'handstand-dan.png.gbsres', res)

write(avatars / 'handstand-dan.png.gbsres', {
    '_resourceType': 'avatar',
    'id': avatar_id,
    'name': 'Handstand Dan',
    'width': 16,
    'height': 16,
    'filename': 'handstand-dan.png'
})

dialogue = [
    {'id': uid('dialogue/1'), 'command': 'EVENT_TEXT',
     'args': {'text': 'HANDSTAND DAN\nCan you hold this?', 'avatarId': avatar_id}},
    {'id': uid('dialogue/2'), 'command': 'EVENT_TEXT',
     'args': {'text': "PAPA WOOK\nYou're upside down."}},
    {'id': uid('dialogue/3'), 'command': 'EVENT_TEXT',
     'args': {'text': "HANDSTAND DAN\nThat wasn't\nthe question.", 'avatarId': avatar_id}}
]
actor = {
    '_resourceType': 'actor',
    'id': actor_id,
    'name': 'Handstand Dan',
    'frame': 0,
    'animate': True,
    'spriteSheetId': sprite_id,
    'prefabId': '',
    'direction': 'down',
    'moveSpeed': 1,
    'animSpeed': 15,
    'paletteId': '',
    'isPinned': False,
    'persistent': False,
    'collisionGroup': '',
    'collisionExtraFlags': [],
    'prefabScriptOverrides': {},
    '_index': 2,
    'symbol': 'actor_handstand_dan',
    'coordinateType': 'tiles',
    'x': 10,
    'y': 11,
    'script': dialogue,
    'startScript': [],
    'updateScript': [],
    'hit1Script': [], 'hit2Script': [], 'hit3Script': []
}
write(scene_dir / 'actors/handstand_dan.gbsres', actor)

manifest = {
    'schema': 'ghost-atlas.wook.c0.handstand-dan.v1',
    'packet': 'WOOK-C0-HANDSTAND-DAN-001',
    'character': 'Handstand Dan',
    'sprite_id': sprite_id,
    'avatar_id': avatar_id,
    'actor_id': actor_id,
    'scene': 'The Questionable Campground',
    'critical_path_blocking': False,
    'visual_qa': 'PENDING_NATIVE_SCREENSHOT',
    'native_build': 'PENDING_EXECUTION'
}
write(root / 'docs/proof/C0-HANDSTAND-DAN-MANIFEST.json', manifest)
print('HANDSTAND_DAN_NATIVE_RESOURCES=PASS')
PY

bash "$ROOT/scripts/audit-c0-handstand-dan-001.sh"

echo "NATIVE_BUILD=START"
proot-distro login ubuntu --shared-tmp --bind "$GA:/root/.ghost-atlas" -- /bin/bash -s <<'INNER'
set -Eeuo pipefail
ROOT="/root/.ghost-atlas/games/WOOK"
if [ ! -d "$ROOT/.git" ] && [ -d "/root/.ghost-atlas/campaigns/WOOK-V4-CARTRIDGE-CLASS-FINAL-001/repo/.git" ]; then
  ROOT="/root/.ghost-atlas/campaigns/WOOK-V4-CARTRIDGE-CLASS-FINAL-001/repo"
fi
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

ROM_SHA="$(sha256sum "$ROOT/releases/native/rom/WOOK.gb" | awk '{print $1}')"
RECEIPT="$ROOT/docs/proof/receipts/WOOK-C0-HANDSTAND-DAN-001-$STAMP.json"
mkdir -p "$(dirname "$RECEIPT")"
jq -n --arg stamp "$STAMP" --arg rom "$ROM_SHA" '{
 schema:"ghost-atlas.wook.c0.handstand-dan-proof.v1",
 packet:"WOOK-C0-HANDSTAND-DAN-001",
 timestamp:$stamp,
 proof:{source_generation:"PASS",native_resource:"PASS",actor_binding:"PASS",native_web:"PASS",rom:"PASS"},
 visual_qa:"PENDING_NATIVE_SCREENSHOT",
 rom_sha256:$rom,
 result:"WOOK_C0_HANDSTAND_DAN_NATIVE_PASS"
}' > "$RECEIPT"
cp "$RECEIPT" "$ROOT/docs/proof/receipts/C0-HANDSTAND-DAN-LATEST.json"

echo "WOOK_C0_HANDSTAND_DAN_NATIVE_PASS"
echo "RECEIPT=$RECEIPT"
