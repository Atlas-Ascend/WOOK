#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

PACKET="WOOK-C00-MVP-COMMAND-TO-PROOF-001"
BRANCH="architecture/character-detail-level10"
OWNER="Atlas-Ascend"
REPO="WOOK"
GA="$HOME/.ghost-atlas"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${WOOK_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export WOOK_ROOT="$ROOT"
cd "$ROOT"

CONTROLLER="$ROOT/scripts/wook-c0-golden-slice-controller.sh"
STATE="$ROOT/docs/proof/c0-golden-slice/state.json"
PROJECT="$ROOT/game/project/WOOK.gbsproj"
MVP_ROOT="$ROOT/releases/mvp/c00"
MVP_WEB="$MVP_ROOT/web"
MVP_ROM_DIR="$MVP_ROOT/rom"
MVP_ROM="$MVP_ROM_DIR/WOOK-C00-MVP.gb"
PUBLIC="$ROOT/site/c00-mvp"
PROOF_ROOT="$ROOT/docs/proof/releases"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"

mkdir -p "$PROOF_ROOT"

echo "======================================================================"
echo " WOOK C00 // COMMAND TO PROOF ROM MVP"
echo " $PACKET"
echo "======================================================================"
echo "ROOT=$ROOT"
echo "BRANCH=$(git branch --show-current)"
echo "HEAD=$(git rev-parse HEAD)"

for cmd in git jq sha256sum curl; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "MISSING_COMMAND=$cmd"; exit 10; }
done

test -s "$CONTROLLER" || { echo "C0_CONTROLLER=MISSING"; exit 11; }
test -s "$PROJECT" || { echo "GB_STUDIO_PROJECT=MISSING"; exit 12; }

echo "[01/10] C00 ARCHITECTURE AUDIT"
WOOK_ROOT="$ROOT" bash "$CONTROLLER" audit

echo "[02/10] MANUFACTURE ALL AUTOMATED PRE-VISUAL C00 GATES"
for _ in $(seq 1 40); do
  WOOK_ROOT="$ROOT" bash "$CONTROLLER" sync >/dev/null || true
  red="$(WOOK_ROOT="$ROOT" bash "$CONTROLLER" next | awk -F= '/^FIRST_RED_GATE=/{print $2; exit}')"
  echo "FIRST_RED_GATE=$red"
  case "$red" in
    VISUAL_QA|REGRESSION|RECEIPT|NONE) break ;;
  esac

  set +e
  WOOK_ROOT="$ROOT" bash "$CONTROLLER" run
  rc=$?
  set -e

  if [ "$rc" -eq 60 ]; then
    red="$(WOOK_ROOT="$ROOT" bash "$CONTROLLER" next | awk -F= '/^FIRST_RED_GATE=/{print $2; exit}')"
    [ "$red" = "VISUAL_QA" ] && break
    echo "AUTOMATION_BOUNDARY=$red"
    exit 20
  fi
  [ "$rc" -eq 0 ] || { echo "C00_AUTOMATION_EXIT=$rc"; exit "$rc"; }
done

WOOK_ROOT="$ROOT" bash "$CONTROLLER" sync >/dev/null || true

test -s "$STATE" || { echo "C00_STATE=MISSING"; exit 21; }

pre=(
  PAPA_WOOK_CONTROLLER SNIFFANY HANDSTAND_DAN RACCOON_ENCOUNTER
  CROCS_0_TO_2 COLLISION_TOPOLOGY HUD PHONE INVENTORY QUEST_LOG
  GROUNDSCORE RESPONSIBILITY WOOK_KARMA SIDE_QUEST SECRET SAVE_RELOAD
  GA_EXIT NATIVE_WEB ROM
)
for gate in "${pre[@]}"; do
  value="$(jq -r --arg g "$gate" '.gates[$g]' "$STATE")"
  [ "$value" = PASS ] || { echo "MVP_PRECONDITION_${gate}=$value"; exit 22; }
  echo "PASS=$gate"
done

echo "[03/10] RESOLVE PROVEN GB STUDIO RUNTIME"
bash "$ROOT/scripts/resolve-gbstudio-runtime.sh"

echo "[04/10] FRESH INTEGRATED MVP BUILD"
rm -rf "$MVP_WEB" "$MVP_ROM_DIR" "$PUBLIC"
mkdir -p "$MVP_WEB" "$MVP_ROM_DIR" "$PUBLIC"

proot-distro login ubuntu \
  --shared-tmp \
  --bind "$GA:/root/.ghost-atlas" \
  --bind "$ROOT:/root/WOOK-CURRENT" \
  -- /bin/bash -s <<'INNER'
set -Eeuo pipefail
ROOT=/root/WOOK-CURRENT
PROJECT="$ROOT/game/project/WOOK.gbsproj"
WEB="$ROOT/releases/mvp/c00/web"
ROM="$ROOT/releases/mvp/c00/rom/WOOK-C00-MVP.gb"
gb-studio-cli make:web "$PROJECT" "$WEB"
test -s "$WEB/index.html"
echo "C00_MVP_NATIVE_WEB=PASS"
gb-studio-cli make:rom "$PROJECT" "$ROM"
test -s "$ROM"
echo "C00_MVP_ROM=PASS"
INNER

cp -a "$MVP_WEB/." "$PUBLIC/"

test -s "$MVP_ROM" || { echo "MVP_ROM=MISSING"; exit 30; }
test -s "$PUBLIC/index.html" || { echo "MVP_WEB=MISSING"; exit 31; }

ROM_SHA="$(sha256sum "$MVP_ROM" | awk '{print $1}')"
WEB_SHA="$(sha256sum "$PUBLIC/index.html" | awk '{print $1}')"
SOURCE_HEAD="$(git rev-parse HEAD)"
VISUAL_STATE="$(jq -r '.gates.VISUAL_QA // "PENDING"' "$STATE")"

BUILD_RECEIPT="$PROOF_ROOT/WOOK-C00-MVP-BUILD-$STAMP.json"
jq -n \
  --arg packet "$PACKET" \
  --arg ts "$STAMP" \
  --arg source "$SOURCE_HEAD" \
  --arg rom "$ROM_SHA" \
  --arg web "$WEB_SHA" \
  --arg visual "$VISUAL_STATE" \
  '{
    schema:"ghost-atlas.wook.c00.mvp-rom.v1",
    packet:$packet,
    chapter:"C00",
    title:"WHERE ARE MY SHOES?",
    timestamp:$ts,
    source_commit:$source,
    proof:{
      automated_previsual_gates:"PASS",
      integrated_native_web:"PASS",
      integrated_native_rom:"PASS",
      visual_qa:$visual
    },
    artifacts:{
      rom:"releases/mvp/c00/rom/WOOK-C00-MVP.gb",
      native_web:"site/c00-mvp/index.html"
    },
    hashes:{rom:$rom,native_web:$web},
    release_class:"PLAYABLE_MVP_CANDIDATE",
    final_chapter_release:false,
    result:"WOOK_C00_MVP_ROM_PASS"
  }' > "$BUILD_RECEIPT"
cp "$BUILD_RECEIPT" "$PROOF_ROOT/C00-MVP-LATEST.json"

echo "[05/10] MVP HASH PROOF"
echo "ROM_SHA256=$ROM_SHA"
echo "WEB_SHA256=$WEB_SHA"
cat "$BUILD_RECEIPT"

echo "[06/10] STAGE ONLY C00 PRODUCT + PROOF OUTPUTS"
git add \
  game/project \
  docs/proof \
  releases/mvp/c00 \
  releases/native \
  site/c00-mvp \
  site/gbstudio

if ! git diff --cached --quiet; then
  git commit -m "release: WOOK C00 ROM MVP $STAMP"
else
  echo "C00_MVP_COMMIT=NO_NEW_DIFF"
fi

echo "[07/10] RECONCILE REMOTE WITHOUT FORCE"
git fetch origin "$BRANCH"
if ! git merge-base --is-ancestor "origin/$BRANCH" HEAD; then
  git rebase "origin/$BRANCH"
fi

RELEASE_COMMIT="$(git rev-parse HEAD)"
git push origin "HEAD:$BRANCH"
REMOTE_COMMIT="$(git ls-remote origin "refs/heads/$BRANCH" | awk '{print $1}')"
[ "$RELEASE_COMMIT" = "$REMOTE_COMMIT" ] || {
  echo "REMOTE_SHA_MISMATCH=FAIL"
  echo "LOCAL=$RELEASE_COMMIT"
  echo "REMOTE=$REMOTE_COMMIT"
  exit 40
}
echo "REMOTE_SHA_EQUALITY=PASS"
echo "RELEASE_COMMIT=$RELEASE_COMMIT"

PLAY_URL="https://raw.githack.com/$OWNER/$REPO/$RELEASE_COMMIT/site/c00-mvp/index.html"
ROM_URL="https://raw.githubusercontent.com/$OWNER/$REPO/$RELEASE_COMMIT/releases/mvp/c00/rom/WOOK-C00-MVP.gb"

echo "[08/10] PUBLIC HTTP PROOF"
HTTP="000"
for _ in 1 2 3 4 5 6; do
  HTTP="$(curl -L -sS -o /dev/null -w '%{http_code}' "$PLAY_URL" || true)"
  [ "$HTTP" = 200 ] && break
  sleep 3
done
[ "$HTTP" = 200 ] || { echo "GITHACK_HTTP=$HTTP"; exit 41; }
echo "GITHACK_HTTP=200"

ROM_HTTP="$(curl -L -sS -o /dev/null -w '%{http_code}' "$ROM_URL" || true)"
[ "$ROM_HTTP" = 200 ] || { echo "ROM_HTTP=$ROM_HTTP"; exit 42; }
echo "ROM_HTTP=200"

echo "[09/10] PUBLICATION RECEIPT"
PUB_STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
PUB_RECEIPT="$PROOF_ROOT/WOOK-C00-MVP-PUBLICATION-$PUB_STAMP.json"
jq -n \
  --arg packet "$PACKET" \
  --arg ts "$PUB_STAMP" \
  --arg commit "$RELEASE_COMMIT" \
  --arg rom "$ROM_SHA" \
  --arg web "$WEB_SHA" \
  --arg play "$PLAY_URL" \
  --arg romurl "$ROM_URL" \
  '{
    schema:"ghost-atlas.wook.c00.mvp-publication.v1",
    packet:$packet,
    timestamp:$ts,
    release_commit:$commit,
    proof:{remote_sha_equality:"PASS",githack_http:"200",rom_http:"200"},
    hashes:{rom:$rom,native_web:$web},
    urls:{play:$play,rom:$romurl},
    truth:{mvp_rom:"PASS",human_visual_qa:"PENDING_OR_SEPARATELY_RECORDED",final_c00_release:"NOT_IMPLIED"},
    result:"WOOK_C00_MVP_COMMAND_TO_PROOF_PASS"
  }' > "$PUB_RECEIPT"
cp "$PUB_RECEIPT" "$PROOF_ROOT/C00-MVP-PUBLICATION-LATEST.json"

git add "$PUB_RECEIPT" "$PROOF_ROOT/C00-MVP-PUBLICATION-LATEST.json"
git commit -m "proof: WOOK C00 MVP publication $PUB_STAMP"
git push origin "HEAD:$BRANCH"
FINAL_HEAD="$(git rev-parse HEAD)"
FINAL_REMOTE="$(git ls-remote origin "refs/heads/$BRANCH" | awk '{print $1}')"
[ "$FINAL_HEAD" = "$FINAL_REMOTE" ] || { echo "FINAL_REMOTE_SHA_MISMATCH=FAIL"; exit 43; }

echo "[10/10] C00 MVP COMMAND TO PROOF PASS"
echo "======================================================================"
echo " WOOK C00 MVP ROM = PASS"
echo "======================================================================"
echo "ROM=$MVP_ROM"
echo "ROM_SHA256=$ROM_SHA"
echo "PLAY_URL=$PLAY_URL"
echo "ROM_URL=$ROM_URL"
echo "RELEASE_COMMIT=$RELEASE_COMMIT"
echo "FINAL_PROOF_COMMIT=$FINAL_HEAD"
echo "VISUAL_QA=$VISUAL_STATE"
echo "WOOK_C00_MVP_COMMAND_TO_PROOF_PASS"
echo "======================================================================"
