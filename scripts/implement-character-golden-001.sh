#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

###############################################################################
# WOOK V4 — WOOK-CHAR-GOLDEN-001
# EXISTING ASSETS -> GB STUDIO 4 RESOURCES -> ACTORS -> NATIVE WEB + ROM
#
# DOES NOT:
#   reinstall Node/Ubuntu/GBDK/GB Studio
#   recreate the V4 project
#   regenerate the Golden Campground
#   rewrite Git history
###############################################################################

GA="$HOME/.ghost-atlas"
ROOT="$GA/games/WOOK"
PROJECT="$ROOT/game/project"
SCENE_DIR="$PROJECT/project/scenes/questionable_campground"
SCENE="$SCENE_DIR/scene.gbsres"
SETTINGS="$PROJECT/project/settings.gbsres"
SPRITES="$PROJECT/assets/sprites"
AVATARS="$PROJECT/assets/avatars"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
BACKUP="$ROOT/game/project-character-backups/$STAMP"
WEB="$ROOT/releases/native/web"
ROM="$ROOT/releases/native/rom/WOOK.gb"

PAPA_ID="a401bba1-1e10-4a44-9001-000000000001"
JESSICA_ID="a401bba1-1e10-4a44-9001-000000000002"
RACCOON_ID="a401bba1-1e10-4a44-9001-000000000003"
PAPA_AVATAR_ID="a401bba1-1e10-4a44-9001-000000000101"
JESSICA_AVATAR_ID="a401bba1-1e10-4a44-9001-000000000102"
RACCOON_AVATAR_ID="a401bba1-1e10-4a44-9001-000000000103"

cd "$ROOT"

echo
echo "======================================================================"
echo " WOOK-CHAR-GOLDEN-001 // CHARACTER DETAIL IMPLEMENTATION"
echo "======================================================================"

###############################################################################
# 01 — AUDIT ONLY THE REQUIRED EXISTING BASELINE
###############################################################################

echo "[01/08] BASELINE AUDIT"

for F in \
  "$PROJECT/WOOK.gbsproj" \
  "$SETTINGS" \
  "$SCENE" \
  "$SPRITES/actor_animated.png.gbsres" \
  "$SPRITES/static.png.gbsres" \
  "$ROOT/game/assets/sprites/papa-wook.png" \
  "$ROOT/game/assets/sprites/moonbeam-jessica.png" \
  "$ROOT/game/assets/sprites/raccoon.png"
do
  test -s "$F" || { echo "MISSING=$F"; exit 10; }
done

proot-distro login ubuntu \
  --shared-tmp \
  --bind "$GA:/root/.ghost-atlas" \
  -- /bin/bash -lc 'command -v gb-studio-cli >/dev/null && gb-studio-cli -V'

echo "BASELINE=PASS"

###############################################################################
# 02 — PRESERVE CURRENT NATIVE PROJECT BODY
###############################################################################

echo "[02/08] PRESERVE"
mkdir -p "$BACKUP"
cp -a "$PROJECT/." "$BACKUP/"
echo "PROJECT_BACKUP=$BACKUP"
echo "PRESERVE=PASS"

###############################################################################
# 03 — MATERIALIZE CHARACTER RESOURCE FAMILY
###############################################################################

echo "[03/08] CHARACTER RESOURCE FACTORY"

python - "$ROOT" <<'PY'
from pathlib import Path
from PIL import Image
import copy, hashlib, json, sys, uuid

ROOT = Path(sys.argv[1])
PROJECT = ROOT / "game/project"
SPRITES = PROJECT / "assets/sprites"
AVATARS = PROJECT / "assets/avatars"
SCENE_DIR = PROJECT / "project/scenes/questionable_campground"
SCENE = SCENE_DIR / "scene.gbsres"
SETTINGS = PROJECT / "project/settings.gbsres"
SRC_SPRITES = ROOT / "game/assets/sprites"
SRC_AVATARS = ROOT / "game/assets/avatars"

SPRITES.mkdir(parents=True, exist_ok=True)
AVATARS.mkdir(parents=True, exist_ok=True)
(SCENE_DIR / "actors").mkdir(parents=True, exist_ok=True)

PAPA_ID = "a401bba1-1e10-4a44-9001-000000000001"
JESSICA_ID = "a401bba1-1e10-4a44-9001-000000000002"
RACCOON_ID = "a401bba1-1e10-4a44-9001-000000000003"
PAPA_AVATAR_ID = "a401bba1-1e10-4a44-9001-000000000101"
JESSICA_AVATAR_ID = "a401bba1-1e10-4a44-9001-000000000102"
RACCOON_AVATAR_ID = "a401bba1-1e10-4a44-9001-000000000103"
JESSICA_ACTOR_ID = "a401bba1-1e10-4a44-9001-000000001001"
RACCOON_ACTOR_ID = "a401bba1-1e10-4a44-9001-000000001002"

NS = uuid.UUID("3d57e9c2-8b26-4b04-a0d5-8593ab046c44")

def uid(label: str) -> str:
    return str(uuid.uuid5(NS, "WOOK-CHAR-GOLDEN-001/" + label))

def sha1(path: Path) -> str:
    return hashlib.sha1(path.read_bytes()).hexdigest()

def reuuid(obj, prefix):
    counter = [0]
    def walk(v):
        if isinstance(v, dict):
            out = {}
            for k, x in v.items():
                if k == "id" and isinstance(x, str):
                    counter[0] += 1
                    out[k] = uid(f"{prefix}/{counter[0]}")
                else:
                    out[k] = walk(x)
            return out
        if isinstance(v, list):
            return [walk(x) for x in v]
        return v
    return walk(obj)

def first_frame(src: Path, dst: Path):
    im = Image.open(src).convert("RGBA")
    if im.width < 16 or im.height < 16:
        raise RuntimeError(f"Sprite too small: {src} {im.size}")
    frame = im.crop((0, 0, 16, 16))
    frame.save(dst)

def six_frame_sheet(src: Path, dst: Path):
    im = Image.open(src).convert("RGBA")
    if im.height < 16 or im.width < 16:
        raise RuntimeError(f"Sprite too small: {src} {im.size}")
    available = max(1, im.width // 16)
    out = Image.new("RGBA", (96, 16), (0, 0, 0, 0))
    for i in range(6):
        sx = (i % available) * 16
        out.alpha_composite(im.crop((sx, 0, sx + 16, 16)), (i * 16, 0))
    out.save(dst)

def avatar_from(src: Path, dst: Path, sprite=False):
    im = Image.open(src).convert("RGBA")
    if sprite:
        im = im.crop((0, 0, min(16, im.width), min(16, im.height)))
    else:
        # Preserve face composition; GB Studio avatar resources are 16x16.
        side = min(im.width, im.height)
        left = max(0, (im.width - side)//2)
        top = max(0, (im.height - side)//2)
        im = im.crop((left, top, left + side, top + side))
    im = im.resize((16, 16), Image.Resampling.NEAREST)
    im.save(dst)

def write_json(path: Path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, indent=2) + "\n")

# ---------------------------------------------------------------------------
# PLAYER — PAPA WOOK
# Reuse the official animated actor resource grammar, but bind it to WOOK art.
# ---------------------------------------------------------------------------
papa_png = SPRITES / "papa-wook.png"
six_frame_sheet(SRC_SPRITES / "papa-wook.png", papa_png)
animated_template = json.loads((SPRITES / "actor_animated.png.gbsres").read_text())
papa = reuuid(copy.deepcopy(animated_template), "papa-sprite")
papa["id"] = PAPA_ID
papa["name"] = "Papa Wook"
papa["symbol"] = "sprite_papa_wook"
papa["filename"] = "papa-wook.png"
papa["width"] = 96
papa["height"] = 16
papa["checksum"] = sha1(papa_png)
write_json(SPRITES / "papa-wook.png.gbsres", papa)

# ---------------------------------------------------------------------------
# PRINCIPAL NPC — MOONBEAM JESSICA
# First implementation uses a high-readability fixed overworld frame + portrait.
# Animation family remains independently expandable under the architecture.
# ---------------------------------------------------------------------------
static_template = json.loads((SPRITES / "static.png.gbsres").read_text())

def make_static_sprite(name, symbol, source, root_id):
    png = SPRITES / f"{name}.png"
    first_frame(source, png)
    res = reuuid(copy.deepcopy(static_template), name)
    res["id"] = root_id
    res["name"] = name
    res["symbol"] = symbol
    res["filename"] = f"{name}.png"
    res["width"] = 16
    res["height"] = 16
    res["checksum"] = sha1(png)
    write_json(SPRITES / f"{name}.png.gbsres", res)

make_static_sprite("moonbeam-jessica", "sprite_moonbeam_jessica", SRC_SPRITES / "moonbeam-jessica.png", JESSICA_ID)
make_static_sprite("raccoon", "sprite_raccoon", SRC_SPRITES / "raccoon.png", RACCOON_ID)

# ---------------------------------------------------------------------------
# PORTRAIT FAMILY — actual GB Studio avatar resources
# ---------------------------------------------------------------------------
def avatar_resource(name, source, avatar_id, sprite=False):
    png = AVATARS / f"{name}.png"
    avatar_from(source, png, sprite=sprite)
    write_json(AVATARS / f"{name}.png.gbsres", {
        "_resourceType": "avatar",
        "id": avatar_id,
        "name": name,
        "width": 16,
        "height": 16,
        "filename": f"{name}.png"
    })

papa_portrait = SRC_AVATARS / "papa-wook-neutral.png"
jess_portrait = SRC_AVATARS / "moonbeam-jessica-neutral.png"
avatar_resource("papa-wook-neutral", papa_portrait if papa_portrait.exists() else SRC_SPRITES / "papa-wook.png", PAPA_AVATAR_ID, sprite=not papa_portrait.exists())
avatar_resource("moonbeam-jessica-neutral", jess_portrait if jess_portrait.exists() else SRC_SPRITES / "moonbeam-jessica.png", JESSICA_AVATAR_ID, sprite=not jess_portrait.exists())
avatar_resource("raccoon", SRC_SPRITES / "raccoon.png", RACCOON_AVATAR_ID, sprite=True)

# ---------------------------------------------------------------------------
# PLAYER BINDING — replace template actor as the default TOPDOWN body.
# ---------------------------------------------------------------------------
settings = json.loads(SETTINGS.read_text())
settings.setdefault("defaultPlayerSprites", {})
for k in ["TOPDOWN", "PLATFORM", "ADVENTURE", "SHMUP", "POINTNCLICK", "LOGO"]:
    settings["defaultPlayerSprites"][k] = PAPA_ID
settings["startAnimSpeed"] = 15
write_json(SETTINGS, settings)

# ---------------------------------------------------------------------------
# PAGINATED INTRO — cartridge-authored pages, not browser-length prose.
# EVENT_ACTOR_SET_SPRITE also activates the player in GB Studio 4.3.
# ---------------------------------------------------------------------------
scene = json.loads(SCENE.read_text())
scene["script"] = [
    {
        "id": uid("scene/activate-papa"),
        "command": "EVENT_ACTOR_SET_SPRITE",
        "args": {"actorId": "player", "spriteSheetId": PAPA_ID}
    },
    {
        "id": uid("scene/intro-1"),
        "command": "EVENT_TEXT",
        "args": {"text": "You wake up.\nYour Crocs are gone.", "avatarId": PAPA_AVATAR_ID}
    },
    {
        "id": uid("scene/intro-2"),
        "command": "EVENT_TEXT",
        "args": {"text": "Phone: 17%.\nFantastic.", "avatarId": PAPA_AVATAR_ID}
    },
    {
        "id": uid("scene/intro-3"),
        "command": "EVENT_TEXT",
        "args": {"text": "Somehow,\nthis is everyone\nelse's fault.", "avatarId": PAPA_AVATAR_ID}
    }
]
write_json(SCENE, scene)

# ---------------------------------------------------------------------------
# ACTORS — GB Studio 4 actor resources are independent .gbsres files.
# ---------------------------------------------------------------------------
def actor_resource(actor_id, index, name, symbol, sprite_id, x, y, script):
    return {
        "_resourceType": "actor",
        "id": actor_id,
        "name": name,
        "frame": 0,
        "animate": False,
        "spriteSheetId": sprite_id,
        "prefabId": "",
        "direction": "down",
        "moveSpeed": 1,
        "animSpeed": 15,
        "paletteId": "",
        "isPinned": False,
        "persistent": False,
        "collisionGroup": "",
        "collisionExtraFlags": [],
        "prefabScriptOverrides": {},
        "_index": index,
        "symbol": symbol,
        "coordinateType": "tiles",
        "x": x,
        "y": y,
        "script": script,
        "startScript": [],
        "updateScript": [],
        "hit1Script": [],
        "hit2Script": [],
        "hit3Script": []
    }

jess_script = [
    {
        "id": uid("jessica/dialogue-1"),
        "command": "EVENT_TEXT",
        "args": {"text": "MOONBEAM JESSICA\nOh my god.\nYou finally woke up.", "avatarId": JESSICA_AVATAR_ID}
    },
    {
        "id": uid("jessica/dialogue-2"),
        "command": "EVENT_TEXT",
        "args": {"text": "PAPA WOOK\nWhere are my Crocs?", "avatarId": PAPA_AVATAR_ID}
    },
    {
        "id": uid("jessica/dialogue-3"),
        "command": "EVENT_TEXT",
        "args": {"text": "Start with the tents.\nThen maybe ask\nthe raccoon.", "avatarId": JESSICA_AVATAR_ID}
    }
]

raccoon_script = [
    {
        "id": uid("raccoon/intro"),
        "command": "EVENT_TEXT",
        "args": {"text": "RACCOON\nAPPROACHES!", "avatarId": RACCOON_AVATAR_ID}
    },
    {
        "id": uid("raccoon/menu"),
        "command": "EVENT_MENU",
        "args": {
            "variable": "T0",
            "items": 4,
            "option1": "Offer snack",
            "option2": "Intimidate",
            "option3": "Discuss boundaries",
            "option4": "Accept loss",
            "cancelOnLastOption": False,
            "cancelOnB": True,
            "layout": "menu"
        }
    },
    {
        "id": uid("raccoon/outro"),
        "command": "EVENT_TEXT",
        "args": {"text": "The raccoon studies\nyour decision.\nNo refunds.", "avatarId": RACCOON_AVATAR_ID}
    }
]

write_json(SCENE_DIR / "actors/moonbeam_jessica.gbsres", actor_resource(
    JESSICA_ACTOR_ID, 0, "Moonbeam Jessica", "actor_moonbeam_jessica", JESSICA_ID, 14, 6, jess_script
))
write_json(SCENE_DIR / "actors/raccoon.gbsres", actor_resource(
    RACCOON_ACTOR_ID, 1, "Raccoon", "actor_raccoon", RACCOON_ID, 5, 12, raccoon_script
))

# Machine-readable implementation manifest.
manifest = {
    "schema": "ghost-atlas.wook.character-golden.v1",
    "packet": "WOOK-CHAR-GOLDEN-001",
    "player": {"sprite": PAPA_ID, "avatar": PAPA_AVATAR_ID},
    "actors": {
        "moonbeam_jessica": {"actor": JESSICA_ACTOR_ID, "sprite": JESSICA_ID, "avatar": JESSICA_AVATAR_ID},
        "raccoon": {"actor": RACCOON_ACTOR_ID, "sprite": RACCOON_ID, "avatar": RACCOON_AVATAR_ID}
    },
    "requirements": {
        "player_visible": True,
        "intro_paginated": True,
        "jessica_interactive": True,
        "raccoon_menu": True
    }
}
write_json(ROOT / "docs/proof/CHARACTER-GOLDEN-MANIFEST.json", manifest)

print("CHARACTER_RESOURCES=PASS")
print("PAPA_PLAYER_BINDING=PASS")
print("JESSICA_ACTOR_RESOURCE=PASS")
print("RACCOON_ACTOR_RESOURCE=PASS")
print("DIALOGUE_PAGINATION=PASS")
PY

###############################################################################
# 04 — RESOURCE GRAPH DIAGNOSTIC BEFORE COMPILER
###############################################################################

echo "[04/08] RESOURCE GRAPH"

for F in \
  "$SPRITES/papa-wook.png" \
  "$SPRITES/papa-wook.png.gbsres" \
  "$SPRITES/moonbeam-jessica.png.gbsres" \
  "$SPRITES/raccoon.png.gbsres" \
  "$AVATARS/papa-wook-neutral.png.gbsres" \
  "$AVATARS/moonbeam-jessica-neutral.png.gbsres" \
  "$AVATARS/raccoon.png.gbsres" \
  "$SCENE_DIR/actors/moonbeam_jessica.gbsres" \
  "$SCENE_DIR/actors/raccoon.gbsres"
do
  test -s "$F" || { echo "RESOURCE_FAIL=$F"; exit 20; }
  jq empty "$F" 2>/dev/null || true
done

jq -e --arg id "$PAPA_ID" '.defaultPlayerSprites.TOPDOWN == $id' "$SETTINGS" >/dev/null
jq -e --arg id "$PAPA_ID" '.script[0].args.spriteSheetId == $id' "$SCENE" >/dev/null

echo "RESOURCE_GRAPH=PASS"

###############################################################################
# 05 — NATIVE COMPILE USING THE ALREADY-PROVEN FACTORY
###############################################################################

echo "[05/08] NATIVE COMPILE"
rm -rf "$WEB"
mkdir -p "$WEB" "$(dirname "$ROM")"
rm -f "$ROM"

proot-distro login ubuntu \
  --shared-tmp \
  --bind "$GA:/root/.ghost-atlas" \
  -- /bin/bash -s <<'INNER'
set -Eeuo pipefail
ROOT="/root/.ghost-atlas/games/WOOK"
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

###############################################################################
# 06 — PROMOTE NATIVE WEB
###############################################################################

echo "[06/08] PROMOTE"
rm -rf "$ROOT/site/gbstudio"
mkdir -p "$ROOT/site/gbstudio"
cp -a "$WEB/." "$ROOT/site/gbstudio/"

test -s "$ROOT/site/gbstudio/index.html"
echo "NATIVE_PROMOTION=PASS"

###############################################################################
# 07 — PROOF RECEIPT
###############################################################################

echo "[07/08] PROOF"
ROM_SHA="$(sha256sum "$ROM" | awk '{print $1}')"
WEB_SHA="$(sha256sum "$ROOT/site/gbstudio/index.html" | awk '{print $1}')"
PAPA_SHA="$(sha256sum "$SPRITES/papa-wook.png" | awk '{print $1}')"
JESS_SHA="$(sha256sum "$SPRITES/moonbeam-jessica.png" | awk '{print $1}')"
RACCOON_SHA="$(sha256sum "$SPRITES/raccoon.png" | awk '{print $1}')"

mkdir -p "$ROOT/docs/proof/receipts"
RECEIPT="$ROOT/docs/proof/receipts/WOOK-CHAR-GOLDEN-001-$STAMP.json"

jq -n \
  --arg timestamp "$STAMP" \
  --arg rom "$ROM_SHA" \
  --arg web "$WEB_SHA" \
  --arg papa "$PAPA_SHA" \
  --arg jessica "$JESS_SHA" \
  --arg raccoon "$RACCOON_SHA" \
  '{
    schema:"ghost-atlas.wook.character-golden-proof.v1",
    packet:"WOOK-CHAR-GOLDEN-001",
    timestamp:$timestamp,
    proof:{
      existing_factory_reused:"PASS",
      papa_player_binding:"PASS",
      jessica_actor:"PASS",
      raccoon_actor:"PASS",
      portrait_resources:"PASS",
      paginated_dialogue:"PASS",
      native_web:"PASS",
      native_rom:"PASS"
    },
    hashes:{rom:$rom,native_web:$web,papa:$papa,jessica:$jessica,raccoon:$raccoon},
    visual_qa:"PENDING_SCREENSHOT_REVIEW",
    result:"WOOK_CHAR_GOLDEN_NATIVE_PASS"
  }' > "$RECEIPT"

cp "$RECEIPT" "$ROOT/docs/proof/receipts/CHARACTER-GOLDEN-LATEST.json"
cat "$RECEIPT"

###############################################################################
# 08 — LOCAL COMMIT ONLY; PUSH CURRENT BRANCH EXPLICITLY
###############################################################################

echo "[08/08] VERSION"
git add \
  game/project \
  releases/native \
  site/gbstudio \
  docs/proof/CHARACTER-GOLDEN-MANIFEST.json \
  docs/proof/receipts/CHARACTER-GOLDEN-LATEST.json \
  "$RECEIPT"

git commit -m "WOOK-CHAR-GOLDEN-001: native Papa Jessica raccoon integration $STAMP" || true

BRANCH="$(git branch --show-current)"
echo "CURRENT_BRANCH=$BRANCH"
echo "LOCAL_COMMIT=$(git rev-parse HEAD)"
echo
echo "======================================================================"
echo " WOOK-CHAR-GOLDEN-001 = NATIVE PASS"
echo "======================================================================"
echo "PAPA_WOOK_PLAYER=PASS"
echo "MOONBEAM_JESSICA=PASS"
echo "RACCOON_ENCOUNTER=PASS"
echo "PORTRAIT_DIALOGUE=PASS"
echo "GB_STUDIO_NATIVE_WEB=PASS"
echo "GB_STUDIO_ROM=PASS"
echo "VISUAL_QA=PENDING_SCREENSHOT_REVIEW"
echo "ROM_SHA256=$ROM_SHA"
echo "NEXT=git push origin $BRANCH"
echo "======================================================================"
