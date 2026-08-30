#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
GA="$HOME/.ghost-atlas"
ROOT="$(git rev-parse --show-toplevel)"
PROJECT="$ROOT/game/project"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
BACKUP="$ROOT/game/project-c0-backups/crocs-collision-$STAMP"
RECEIPTS="$ROOT/docs/proof/receipts"

echo "=== WOOK-C0-CROCS-COLLISION-001 ==="
for f in "$PROJECT/WOOK.gbsproj" "$PROJECT/project/scenes/questionable_campground/scene.gbsres" "$PROJECT/project/variables.gbsres" "$ROOT/tools/build-c0-crocs-collision.py" "$ROOT/design/gameplay/C0-CAMPGROUND-TOPOLOGY.json"; do
  test -s "$f" || { echo "MISSING=$f"; exit 10; }
done

echo "[01/06] PRESERVE"
mkdir -p "$BACKUP"; cp -a "$PROJECT/." "$BACKUP/"
echo "PROJECT_BACKUP=$BACKUP"

echo "[02/06] MATERIALIZE STATE + PICKUPS + COLLISION"
python "$ROOT/tools/build-c0-crocs-collision.py" --root "$ROOT"

echo "[03/06] STATIC / ROUTE AUDIT"
bash "$ROOT/scripts/audit-c0-crocs-collision-001.sh"

echo "[04/06] NATIVE COMPILE"
ROOT_BIND="$ROOT"
proot-distro login ubuntu --shared-tmp --bind "$GA:/root/.ghost-atlas" --bind "$ROOT_BIND:/root/WOOK-CURRENT" -- /bin/bash -s <<'INNER'
set -Eeuo pipefail
ROOT="/root/WOOK-CURRENT"
PROJECT="$ROOT/game/project/WOOK.gbsproj"
WEB="$ROOT/releases/native/web"
ROM="$ROOT/releases/native/rom/WOOK.gb"
rm -rf "$WEB"; mkdir -p "$WEB" "$(dirname "$ROM")"
gb-studio-cli make:web "$PROJECT" "$WEB"
test -s "$WEB/index.html"
echo "GB_STUDIO_NATIVE_WEB=PASS"
gb-studio-cli make:rom "$PROJECT" "$ROM"
test -s "$ROM"
echo "GB_STUDIO_ROM=PASS"
INNER

echo "[05/06] PROMOTE + HASH"
rm -rf "$ROOT/site/gbstudio"; mkdir -p "$ROOT/site/gbstudio"; cp -a "$ROOT/releases/native/web/." "$ROOT/site/gbstudio/"
ROM_SHA="$(sha256sum "$ROOT/releases/native/rom/WOOK.gb" | awk '{print $1}')"
WEB_SHA="$(sha256sum "$ROOT/site/gbstudio/index.html" | awk '{print $1}')"

echo "[06/06] RECEIPT"
mkdir -p "$RECEIPTS"
R="$RECEIPTS/WOOK-C0-CROCS-COLLISION-001-$STAMP.json"
jq -n --arg ts "$STAMP" --arg rom "$ROM_SHA" --arg web "$WEB_SHA" '{schema:"ghost-atlas.wook.c0.crocs-collision-proof.v1",packet:"WOOK-C0-CROCS-COLLISION-001",timestamp:$ts,proof:{preserve:"PASS",state_resources:"PASS",collision_topology:"PASS",route_safety:"PASS",native_web:"PASS",native_rom:"PASS"},hashes:{rom:$rom,native_web:$web},gameplay_qa:"PENDING_NATIVE_PLAYTEST",result:"WOOK_C0_CROCS_COLLISION_NATIVE_PASS"}' > "$R"
cp "$R" "$RECEIPTS/C0-CROCS-COLLISION-LATEST.json"
cat "$R"
echo "WOOK_C0_CROCS_COLLISION_NATIVE_PASS"
echo "NEXT=HUD_PHONE_INVENTORY_QUEST_LOG"
