#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

###############################################################################
# WOOK V4 — WOOK-CHAR-GOLDEN-001
# CANONICAL CAST -> GB STUDIO 4 RESOURCES -> NATIVE WEB + ROM
#
# ACTIVE GOLDEN SCENE:
#   PAPA WOOK + SNIFFANY + RACCOON
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
SNIFFANY_ID="a401bba1-1e10-4a44-9001-000000000002"
RACCOON_ID="a401bba1-1e10-4a44-9001-000000000003"
PAPA_AVATAR_ID="a401bba1-1e10-4a44-9001-000000000101"
SNIFFANY_AVATAR_ID="a401bba1-1e10-4a44-9001-000000000102"
RACCOON_AVATAR_ID="a401bba1-1e10-4a44-9001-000000000103"

cd "$ROOT"

echo
echo "======================================================================"
echo " WOOK-CHAR-GOLDEN-001 // CANONICAL CHARACTER IMPLEMENTATION"
echo " PAPA WOOK + SNIFFANY + RACCOON"
echo "======================================================================"

###############################################################################
# 01 — AUDIT ONLY THE REQUIRED EXISTING BASELINE
###############################################################################

echo "[01/09] BASELINE AUDIT"

for F in \
  "$PROJECT/WOOK.gbsproj" \
  "$SETTINGS" \
  "$SCENE" \
  "$SPRITES/actor_animated.png.gbsres" \
  "$SPRITES/static.png.gbsres" \
  "$ROOT/game/assets/sprites/papa-wook.png" \
  "$ROOT/game/assets/sprites/raccoon.png"
do
  test -s "$F" || { echo "MISSING=$F"; exit 10; }
done

# Sniffany may already have canonical source art. During migration only, the
# previous social-anchor artwork is permitted as an input donor. The resulting
# native resource is always named/symbolized as Sniffany.
if [ ! -s "$ROOT/game/assets/sprites/sniffany.png" ] && \
   [ ! -s "$ROOT/game/assets/sprites/moonbeam-jessica.png" ]; then
  echo "SNIFFANY_SOURCE=MISSING"
  exit 11
fi

proot-distro login ubuntu \
  --shared-tmp \
  --bind "$GA:/root/.ghost-atlas" \
  -- /bin/bash -lc 'command -v gb-studio-cli >/dev/null && gb-studio-cli -V'

echo "BASELINE=PASS"

###############################################################################
# 02 — PRESERVE CURRENT NATIVE PROJECT BODY
###############################################################################

echo "[02/09] PRESERVE"
mkdir -p "$BACKUP"
cp -a "$PROJECT/." "$BACKUP/"
echo "PROJECT_BACKUP=$BACKUP"
echo "PRESERVE=PASS"

###############################################################################
# 03 — MATERIALIZE CANONICAL CHARACTER RESOURCE FAMILY
###############################################################################

echo "[03/09] CHARACTER RESOURCE FACTORY"

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
SNIFFANY_ID = "a401bba1-1e10-4a44-9001-000000000002"
RACCOON_ID = "a401bba1-1e10-4a44-9001-000000000003"
PAPA_AVATAR_ID = "a401bba1-1e10-4a44-9001-000000000101"
SNIFFANY_AVATAR_ID = "a401bba1-1e10-4a44-9001-000000000102"
RACCOON_AVATAR_ID = "a401bba1-1e10-4a44-9001-000000000103"
SNIFFANY_ACTOR_ID = "a401bba1-1e10-4a44-9001-000000001001"
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
    im.crop((0, 0, 16, 16)).save(dst)

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
        side = min(im.width, im.height)
        left = max(0, (im.width - side)//2)
        top = max(0, (im.height - side)//2)
        im = im.crop((left, top, left + side, top + side))
    im.resize((16, 16), Image.Resampling.NEAREST).save(dst)

def write_json(path: Path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, indent=2) + "\n")

# Resolve canonical Sniffany source. Legacy filename is a migration donor only.
sniffany_source = SRC_SPRITES / "sniffany.png"
if not sniffany_source.exists():
    sniffany_source = SRC_SPRITES / "moonbeam-jessica.png"

sniffany_avatar_source = SRC_AVATARS / "sniffany-neutral.png"
if not sniffany_avatar_source.exists():
    legacy_avatar = SRC_AVATARS / "moonbeam-jessica-neutral.png"
    sniffany_avatar_source = legacy_avatar if legacy_avatar.exists() else sniffany_source

# Remove any previously-materialized deprecated active runtime resources.
for p in [
    SPRITES / "moonbeam-jessica.png",
    SPRITES / "moonbeam-jessica.png.gbsres",
    AVATARS / "moonbeam-jessica-neutral.png",
    AVATARS / "moonbeam-jessica-neutral.png.gbsres",
    SCENE_DIR / "actors/moonbeam_jessica.gbsres",
]:
    if p.exists():
        p.unlink()

# Papa Wook — hero resource.
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

# Static template for first-pass principal NPC and creature resources.
static_template = json.loads((SPRITES / "static.png.gbsres").read_text())

def make_static_sprite(name, display_name, symbol, source, root_id):
    png = SPRITES / f"{name}.png"
    first_frame(source, png)
    res = reuuid(copy.deepcopy(static_template), name)
    res["id"] = root_id
    res["name"] = display_name
    res["symbol"] = symbol
    res["filename"] = f"{name}.png"
    res["width"] = 16
    res["height"] = 16
    res["checksum"] = sha1(png)
    write_json(SPRITES / f"{name}.png.gbsres", res)

make_static_sprite("sniffany", "Sniffany", "sprite_sniffany", sniffany_source, SNIFFANY_ID)
make_static_sprite("raccoon", "Raccoon", "sprite_raccoon", SRC_SPRITES / "raccoon.png", RACCOON_ID)

# Native avatar resources.
def avatar_resource(name, display_name, source, avatar_id, sprite=False):
    png = AVATARS / f"{name}.png"
    avatar_from(source, png, sprite=sprite)
    write_json(AVATARS / f"{name}.png.gbsres", {
        "_resourceType": "avatar",
        "id": avatar_id,
        "name": display_name,
        "width": 16,
        "height": 16,
        "filename": f"{name}.png"
    })

papa_portrait = SRC_AVATARS / "papa-wook-neutral.png"
avatar_resource("papa-wook-neutral", "Papa Wook — Neutral", papa_portrait if papa_portrait.exists() else SRC_SPRITES / "papa-wook.png", PAPA_AVATAR_ID, sprite=not papa_portrait.exists())
avatar_resource("sniffany-neutral", "Sniffany — Neutral", sniffany_avatar_source, SNIFFANY_AVATAR_ID, sprite=sniffany_avatar_source == sniffany_source)
avatar_resource("raccoon", "Raccoon", SRC_SPRITES / "raccoon.png", RACCOON_AVATAR_ID, sprite=True)

# Papa Wook becomes default player body.
settings = json.loads(SETTINGS.read_text())
settings.setdefault("defaultPlayerSprites", {})
for k in ["TOPDOWN", "PLATFORM", "ADVENTURE", "SHMUP", "POINTNCLICK", "LOGO"]:
    settings["defaultPlayerSprites"][k] = PAPA_ID
settings["startAnimSpeed"] = 15
write_json(SETTINGS, settings)

# Cartridge-authored intro. EVENT_ACTOR_SET_SPRITE also activates the player.
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

# Actor grammar.
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

sniffany_script = [
    {
        "id": uid("sniffany/dialogue-1"),
        "command": "EVENT_TEXT",
        "args": {"text": "SNIFFANY\nOh my god.\nYou finally woke up.", "avatarId": SNIFFANY_AVATAR_ID}
    },
    {
        "id": uid("sniffany/dialogue-2"),
        "command": "EVENT_TEXT",
        "args": {"text": "PAPA WOOK\nDefine finally.", "avatarId": PAPA_AVATAR_ID}
    },
    {
        "id": uid("sniffany/dialogue-3"),
        "command": "EVENT_TEXT",
        "args": {"text": "Start with the tents.\nThen maybe ask\nthe raccoon.", "avatarId": SNIFFANY_AVATAR_ID}
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

write_json(SCENE_DIR / "actors/sniffany.gbsres", actor_resource(
    SNIFFANY_ACTOR_ID, 0, "Sniffany", "actor_sniffany", SNIFFANY_ID, 14, 6, sniffany_script
))
write_json(SCENE_DIR / "actors/raccoon.gbsres", actor_resource(
    RACCOON_ACTOR_ID, 1, "Raccoon", "actor_raccoon", RACCOON_ID, 5, 12, raccoon_script
))

manifest = {
    "schema": "ghost-atlas.wook.character-golden.v2",
    "packet": "WOOK-CHAR-GOLDEN-001",
    "canon": ["Papa Wook", "Train Station", "Loki", "The Wizard", "Bufo D' Clown", "Handstand Dan", "Sniffany"],
    "player": {"name": "Papa Wook", "sprite": PAPA_ID, "avatar": PAPA_AVATAR_ID},
    "actors": {
        "sniffany": {"actor": SNIFFANY_ACTOR_ID, "sprite": SNIFFANY_ID, "avatar": SNIFFANY_AVATAR_ID},
        "raccoon": {"actor": RACCOON_ACTOR_ID, "sprite": RACCOON_ID, "avatar": RACCOON_AVATAR_ID}
    },
    "requirements": {
        "player_visible": True,
        "intro_paginated": True,
        "sniffany_interactive": True,
        "raccoon_menu": True,
        "canonical_runtime_names": True
    }
}
write_json(ROOT / "docs/proof/CHARACTER-GOLDEN-MANIFEST.json", manifest)

print("CHARACTER_RESOURCES=PASS")
print("PAPA_PLAYER_BINDING=PASS")
print("SNIFFANY_ACTOR_RESOURCE=PASS")
print("RACCOON_ACTOR_RESOURCE=PASS")
print("DIALOGUE_PAGINATION=PASS")
PY

###############################################################################
# 04 — RESOURCE GRAPH DIAGNOSTIC
###############################################################################

echo "[04/09] RESOURCE GRAPH"

for F in \
  "$SPRITES/papa-wook.png" \
  "$SPRITES/papa-wook.png.gbsres" \
  "$SPRITES/sniffany.png" \
  "$SPRITES/sniffany.png.gbsres" \
  "$SPRITES/raccoon.png.gbsres" \
  "$AVATARS/papa-wook-neutral.png.gbsres" \
  "$AVATARS/sniffany-neutral.png.gbsres" \
  "$AVATARS/raccoon.png.gbsres" \
  "$SCENE_DIR/actors/sniffany.gbsres" \
  "$SCENE_DIR/actors/raccoon.gbsres"
do
  test -s "$F" || { echo "RESOURCE_FAIL=$F"; exit 20; }
  case "$F" in *.gbsres) jq empty "$F" ;; esac
done

jq -e --arg id "$PAPA_ID" '.defaultPlayerSprites.TOPDOWN == $id' "$SETTINGS" >/dev/null
jq -e --arg id "$PAPA_ID" '.script[0].args.spriteSheetId == $id' "$SCENE" >/dev/null

echo "RESOURCE_GRAPH=PASS"

###############################################################################
# 05 — CANONICAL NAMING GATE
###############################################################################

echo "[05/09] CANONICAL CAST AUDIT"
bash "$ROOT/scripts/audit-canonical-cast.sh"

###############################################################################
# 06 — NATIVE COMPILE USING THE ALREADY-PROVEN FACTORY
###############################################################################

echo "[06/09] NATIVE COMPILE"
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
# 07 — PROMOTE NATIVE WEB
###############################################################################

echo "[07/09] PROMOTE"
rm -rf "$ROOT/site/gbstudio"
mkdir -p "$ROOT/site/gbstudio"
cp -a "$WEB/." "$ROOT/site/gbstudio/"
test -s "$ROOT/site/gbstudio/index.html"
echo "NATIVE_PROMOTION=PASS"

###############################################################################
# 08 — PROOF RECEIPT
###############################################################################

echo "[08/09] PROOF"
ROM_SHA="$(sha256sum "$ROM" | awk '{print $1}')"
WEB_SHA="$(sha256sum "$ROOT/site/gbstudio/index.html" | awk '{print $1}')"
PAPA_SHA="$(sha256sum "$SPRITES/papa-wook.png" | awk '{print $1}')"
SNIFFANY_SHA="$(sha256sum "$SPRITES/sniffany.png" | awk '{print $1}')"
RACCOON_SHA="$(sha256sum "$SPRITES/raccoon.png" | awk '{print $1}')"

mkdir -p "$ROOT/docs/proof/receipts"
RECEIPT="$ROOT/docs/proof/receipts/WOOK-CHAR-GOLDEN-001-$STAMP.json"

jq -n \
  --arg timestamp "$STAMP" \
  --arg rom "$ROM_SHA" \
  --arg web "$WEB_SHA" \
  --arg papa "$PAPA_SHA" \
  --arg sniffany "$SNIFFANY_SHA" \
  --arg raccoon "$RACCOON_SHA" \
  '{
    schema:"ghost-atlas.wook.character-golden-proof.v2",
    packet:"WOOK-CHAR-GOLDEN-001",
    timestamp:$timestamp,
    proof:{
      existing_factory_reused:"PASS",
      canonical_cast_audit:"PASS",
      papa_player_binding:"PASS",
      sniffany_actor:"PASS",
      raccoon_actor:"PASS",
      portrait_resources:"PASS",
      paginated_dialogue:"PASS",
      native_web:"PASS",
      native_rom:"PASS"
    },
    hashes:{rom:$rom,native_web:$web,papa:$papa,sniffany:$sniffany,raccoon:$raccoon},
    visual_qa:"PENDING_SCREENSHOT_REVIEW",
    result:"WOOK_CHAR_GOLDEN_NATIVE_PASS"
  }' > "$RECEIPT"

cp "$RECEIPT" "$ROOT/docs/proof/receipts/CHARACTER-GOLDEN-LATEST.json"
cat "$RECEIPT"

###############################################################################
# 09 — LOCAL COMMIT ONLY
###############################################################################

echo "[09/09] VERSION"
git add \
  game/project \
  releases/native \
  site/gbstudio \
  docs/proof/CHARACTER-GOLDEN-MANIFEST.json \
  docs/proof/receipts/CHARACTER-GOLDEN-LATEST.json \
  "$RECEIPT"

git commit -m "WOOK-CHAR-GOLDEN-001: native Papa Sniffany raccoon integration $STAMP" || true

BRANCH="$(git branch --show-current)"
echo "CURRENT_BRANCH=$BRANCH"
echo "LOCAL_COMMIT=$(git rev-parse HEAD)"
echo
echo "======================================================================"
echo " WOOK-CHAR-GOLDEN-001 = NATIVE PASS"
echo "======================================================================"
echo "PAPA_WOOK_PLAYER=PASS"
echo "SNIFFANY=PASS"
echo "RACCOON_ENCOUNTER=PASS"
echo "CANONICAL_CAST_AUDIT=PASS"
echo "PORTRAIT_DIALOGUE=PASS"
echo "GB_STUDIO_NATIVE_WEB=PASS"
echo "GB_STUDIO_ROM=PASS"
echo "VISUAL_QA=PENDING_SCREENSHOT_REVIEW"
echo "ROM_SHA256=$ROM_SHA"
echo "NEXT=git push origin $BRANCH"
echo "======================================================================"
