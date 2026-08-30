#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="${WOOK_ROOT:-$(git rev-parse --show-toplevel)}"
GA="$HOME/.ghost-atlas"
PROJECT="$ROOT/game/project"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
BACKUP="$ROOT/game/project-c0-backups/secret-$STAMP"
RECEIPTS="$ROOT/docs/proof/receipts"
WEB="$ROOT/releases/native/web"
ROM="$ROOT/releases/native/rom/WOOK.gb"

cd "$ROOT"
echo "======================================================================"
echo " WOOK-C0-SECRET-001 // THE CEREMONIAL ZIP TIE"
echo "======================================================================"
for f in \
  "$PROJECT/WOOK.gbsproj" \
  "$ROOT/tools/build-c0-secret.py" \
  "$ROOT/scripts/audit-c0-secret-001.sh" \
  "$ROOT/scripts/resolve-gbstudio-runtime.sh"
do test -s "$f" || { echo "MISSING=$f"; exit 10; }; done

echo "[01/07] RUNTIME"
bash "$ROOT/scripts/resolve-gbstudio-runtime.sh"

echo "[02/07] PRESERVE"
mkdir -p "$BACKUP"
cp -a "$PROJECT/." "$BACKUP/"
echo "PROJECT_BACKUP=$BACKUP"

echo "[03/07] MATERIALIZE SECRET"
python "$ROOT/tools/build-c0-secret.py" --root "$ROOT"

echo "[04/07] STATIC AUDIT"
bash "$ROOT/scripts/audit-c0-secret-001.sh"

echo "[05/07] NATIVE COMPILE"
rm -rf "$WEB"
mkdir -p "$WEB" "$(dirname "$ROM")"
rm -f "$ROM"
proot-distro login ubuntu \
  --shared-tmp \
  --bind "$GA:/root/.ghost-atlas" \
  --bind "$ROOT:/root/WOOK-CURRENT" \
  -- /bin/bash -s <<'INNER'
set -Eeuo pipefail
ROOT="/root/WOOK-CURRENT"
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

echo "[06/07] PROMOTE + HASH"
rm -rf "$ROOT/site/gbstudio"
mkdir -p "$ROOT/site/gbstudio"
cp -a "$WEB/." "$ROOT/site/gbstudio/"
ROM_SHA="$(sha256sum "$ROM" | awk '{print $1}')"
WEB_SHA="$(sha256sum "$ROOT/site/gbstudio/index.html" | awk '{print $1}')"

echo "[07/07] RECEIPT"
mkdir -p "$RECEIPTS"
R="$RECEIPTS/WOOK-C0-SECRET-001-$STAMP.json"
jq -n \
  --arg ts "$STAMP" \
  --arg rom "$ROM_SHA" \
  --arg web "$WEB_SHA" \
  '{
    schema:"ghost-atlas.wook.c0.secret-proof.v1",
    packet:"WOOK-C0-SECRET-001",
    secret:"SECRET-C00-001_THE_CEREMONIAL_ZIP_TIE",
    stable_item_id:"ITEM-WOOK-CEREMONIAL-ZIP-TIE",
    timestamp:$ts,
    proof:{
      native_resource:"PASS",
      one_time_guard:"PASS",
      stable_item_identity:"PASS",
      groundscore_reward:"PASS",
      native_web:"PASS",
      native_rom:"PASS"
    },
    hashes:{rom:$rom,native_web:$web},
    future_callback:"RESERVED_NOT_YET_PROVEN",
    gameplay_qa:"PENDING_NATIVE_PLAYTEST",
    result:"WOOK_C0_SECRET_NATIVE_PASS"
  }' > "$R"
cp "$R" "$RECEIPTS/C0-SECRET-LATEST.json"
cat "$R"
echo "WOOK_C0_SECRET_NATIVE_PASS"
echo "NEXT=SAVE_RELOAD"
