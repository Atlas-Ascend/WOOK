#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

OWNER="Atlas-Ascend"
REPO="WOOK"
BRANCH="architecture/character-detail-level10"
CAMPAIGN="WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001"
GA="$HOME/.ghost-atlas"
PRIMARY="$GA/games/WOOK"
SAFE="$GA/campaigns/$CAMPAIGN/repo"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"

# Prefer the safe production checkout because it owns generated C00 state.
if [ -n "${WOOK_ROOT:-}" ] && [ -d "$WOOK_ROOT/.git" ]; then
  ROOT="$WOOK_ROOT"
elif [ -d "$SAFE/.git" ]; then
  ROOT="$SAFE"
elif [ -d "$PRIMARY/.git" ]; then
  ROOT="$PRIMARY"
else
  echo "WOOK_ROOT=MISSING"
  exit 10
fi

export WOOK_ROOT="$ROOT"
cd "$ROOT"

CTRL="$ROOT/scripts/wook-c0-golden-slice-controller.sh"
PUBLISH="$ROOT/scripts/publish-c00-mvp-to-main.sh"
REGRESS="$ROOT/scripts/run-c0-regression-001.sh"
STATE="$ROOT/docs/proof/c0-golden-slice/state.json"

STABLE_URL="https://raw.githack.com/$OWNER/$REPO/main/site/golden/index.html"
DIRECT_URL="https://raw.githack.com/$OWNER/$REPO/main/site/c00-mvp/index.html"
ROM_URL="https://raw.githubusercontent.com/$OWNER/$REPO/main/releases/mvp/c00/rom/WOOK-C00-MVP.gb"

for cmd in git jq curl sha256sum; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "MISSING_COMMAND=$cmd"; exit 11; }
done

for f in "$CTRL" "$PUBLISH" "$REGRESS"; do
  [ -s "$f" ] || { echo "MISSING_SCRIPT=$f"; exit 12; }
done

echo "======================================================================"
echo " WOOK C00 // WHERE ARE MY SHOES? // FINAL COMMAND TO PROOF"
echo "======================================================================"
echo "ROOT=$ROOT"
echo "HEAD=$(git rev-parse HEAD)"
echo "MISSION=MANUFACTURE_HOST_VISUALLY_ACCEPT_REGRESS_QUALIFY_PROVE"
echo

# ----------------------------------------------------------------------
# 01 — Audit
# ----------------------------------------------------------------------
echo "[01/12] C00 CONTROL-PLANE AUDIT"
WOOK_ROOT="$ROOT" bash "$CTRL" audit

# ----------------------------------------------------------------------
# 02 — Manufacture every automated gate until the human visual boundary.
# ----------------------------------------------------------------------
echo "[02/12] MANUFACTURE C00 TO VISUAL BOUNDARY"
for _ in $(seq 1 64); do
  WOOK_ROOT="$ROOT" bash "$CTRL" sync >/dev/null || true
  red="$(WOOK_ROOT="$ROOT" bash "$CTRL" next | awk -F= '/^FIRST_RED_GATE=/{print $2; exit}')"
  echo "FIRST_RED_GATE=$red"
  case "$red" in
    VISUAL_QA|REGRESSION|RECEIPT|NONE) break ;;
  esac

  set +e
  WOOK_ROOT="$ROOT" bash "$CTRL" run
  rc=$?
  set -e

  if [ "$rc" -eq 60 ]; then
    red="$(WOOK_ROOT="$ROOT" bash "$CTRL" next | awk -F= '/^FIRST_RED_GATE=/{print $2; exit}')"
    [ "$red" = "VISUAL_QA" ] && break
    echo "UNIMPLEMENTED_OR_MANUAL_BOUNDARY=$red"
    exit 20
  fi
  [ "$rc" -eq 0 ] || { echo "C00_MANUFACTURE_EXIT=$rc"; exit "$rc"; }
done

WOOK_ROOT="$ROOT" bash "$CTRL" sync >/dev/null || true
[ -s "$STATE" ] || { echo "C00_STATE=MISSING"; exit 21; }

PRE=(
  PAPA_WOOK_CONTROLLER SNIFFANY HANDSTAND_DAN RACCOON_ENCOUNTER
  CROCS_0_TO_2 COLLISION_TOPOLOGY HUD PHONE INVENTORY QUEST_LOG
  GROUNDSCORE RESPONSIBILITY WOOK_KARMA SIDE_QUEST SECRET SAVE_RELOAD
  GA_EXIT NATIVE_WEB ROM
)
for gate in "${PRE[@]}"; do
  v="$(jq -r --arg g "$gate" '.gates[$g] // "MISSING"' "$STATE")"
  [ "$v" = "PASS" ] || { echo "PREVISUAL_GATE_${gate}=$v"; exit 22; }
  echo "PASS=$gate"
done

# ----------------------------------------------------------------------
# 03 — Promote the exact generated candidate to MAIN. No rebuild here.
# ----------------------------------------------------------------------
echo "[03/12] HOST GENERATED C00 ON MAIN"
WOOK_ROOT="$ROOT" bash "$PUBLISH"

# ----------------------------------------------------------------------
# 04 — Prove public candidate URLs before asking for visual acceptance.
# ----------------------------------------------------------------------
echo "[04/12] PUBLIC CANDIDATE HTTP PROOF"
for pair in "STABLE:$STABLE_URL" "DIRECT:$DIRECT_URL" "ROM:$ROM_URL"; do
  name="${pair%%:*}"; url="${pair#*:}"
  code="000"
  for _ in 1 2 3 4 5 6; do
    code="$(curl -L -sS -o /dev/null -w '%{http_code}' "$url" || true)"
    [ "$code" = 200 ] && break
    sleep 3
  done
  echo "${name}_HTTP=$code"
  [ "$code" = 200 ] || exit 30
done

# ----------------------------------------------------------------------
# 05 — Open the exact hosted build on Android when possible.
# ----------------------------------------------------------------------
echo "[05/12] OPEN HOSTED C00"
echo "STABLE_PLAY_URL=$STABLE_URL"
echo "DIRECT_C00_URL=$DIRECT_URL"
if command -v termux-open-url >/dev/null 2>&1; then
  termux-open-url "$DIRECT_URL" >/dev/null 2>&1 || true
elif command -v am >/dev/null 2>&1; then
  am start -a android.intent.action.VIEW -d "$DIRECT_URL" >/dev/null 2>&1 || true
fi

echo
echo "======================================================================"
echo " HUMAN RELEASE GATE"
echo "======================================================================"
echo "Play the hosted C00 candidate now."
echo "Verify title, Papa movement, Sniffany, Handstand Dan, raccoon, Crocs,"
echo "HUD, menus, side quest, secret, save/load, and the GA exit."
echo
echo "Type exactly PASS to accept this hosted cartridge candidate."
echo "Anything else aborts release without falsifying proof."
printf '> '
read -r VISUAL_VERDICT
if [ "$VISUAL_VERDICT" != "PASS" ]; then
  echo "VISUAL_QA=NOT_ACCEPTED"
  echo "C00_RELEASE=BLOCKED_TRUTHFULLY"
  exit 40
fi

# ----------------------------------------------------------------------
# 06 — Record human visual/playtest acceptance against current artifacts.
# ----------------------------------------------------------------------
echo "[06/12] RECORD HUMAN VISUAL PLAYTEST PASS"
WOOK_ROOT="$ROOT" bash "$CTRL" visual PASS "Hosted C00 candidate reviewed on Android and accepted during final command-to-proof"

# ----------------------------------------------------------------------
# 07 — Integrated regression after human acceptance.
# ----------------------------------------------------------------------
echo "[07/12] INTEGRATED C00 REGRESSION"
WOOK_ROOT="$ROOT" bash "$REGRESS"
WOOK_ROOT="$ROOT" bash "$CTRL" sync

red="$(WOOK_ROOT="$ROOT" bash "$CTRL" next | awk -F= '/^FIRST_RED_GATE=/{print $2; exit}')"
echo "POST_REGRESSION_FIRST_RED=$red"
[ "$red" = "RECEIPT" ] || { echo "REGRESSION_DID_NOT_CLOSE_C00=$red"; exit 50; }

# ----------------------------------------------------------------------
# 08 — Create canonical chapter release receipt.
# ----------------------------------------------------------------------
echo "[08/12] C00 CHAPTER RELEASE RECEIPT"
WOOK_ROOT="$ROOT" bash "$CTRL" receipt
WOOK_ROOT="$ROOT" bash "$CTRL" sync

result="$(jq -r '.result // ""' "$STATE")"
[ "$result" = "QUALIFIED" ] || { echo "C00_STATE_RESULT=$result"; exit 51; }
[ -s "$ROOT/docs/proof/chapters/C00-LATEST.json" ] || { echo "C00_RELEASE_RECEIPT=MISSING"; exit 52; }
jq -e '.result=="WOOK_C00_RELEASE_PASS"' "$ROOT/docs/proof/chapters/C00-LATEST.json" >/dev/null || {
  echo "C00_RELEASE_RECEIPT=FAIL"
  exit 53
}
echo "WOOK_C00_RELEASE_PASS=LOCAL_PROVEN"

# ----------------------------------------------------------------------
# 09 — Commit only C00 product/proof surfaces to the production branch.
# ----------------------------------------------------------------------
echo "[09/12] FREEZE QUALIFIED C00 IN PRODUCTION BRANCH"
git add \
  game/project \
  game/assets \
  docs/proof \
  releases/native \
  releases/mvp/c00 \
  site/gbstudio \
  site/c00-mvp 2>/dev/null || true

if ! git diff --cached --quiet; then
  git commit -m "release: qualify WOOK C00 Where Are My Shoes $STAMP"
else
  echo "QUALIFICATION_COMMIT=NO_NEW_DIFF"
fi

git fetch origin "$BRANCH"
if ! git merge-base --is-ancestor "origin/$BRANCH" HEAD; then
  git rebase "origin/$BRANCH"
fi

git push origin "HEAD:$BRANCH"
PROD_HEAD="$(git rev-parse HEAD)"
PROD_REMOTE="$(git ls-remote origin "refs/heads/$BRANCH" | awk '{print $1}')"
[ "$PROD_HEAD" = "$PROD_REMOTE" ] || { echo "PRODUCTION_REMOTE_SHA_EQUALITY=FAIL"; exit 60; }
echo "PRODUCTION_REMOTE_SHA_EQUALITY=PASS"

# ----------------------------------------------------------------------
# 10 — Republish the post-regression qualified artifact to main.
# ----------------------------------------------------------------------
echo "[10/12] PROMOTE QUALIFIED C00 TO MAIN"
WOOK_ROOT="$ROOT" bash "$PUBLISH"

# ----------------------------------------------------------------------
# 11 — Final public proof after qualification.
# ----------------------------------------------------------------------
echo "[11/12] FINAL PUBLIC PROOF"
for pair in "STABLE:$STABLE_URL" "DIRECT:$DIRECT_URL" "ROM:$ROM_URL"; do
  name="${pair%%:*}"; url="${pair#*:}"
  code="000"
  for _ in 1 2 3 4 5 6; do
    code="$(curl -L -sS -o /dev/null -w '%{http_code}' "$url" || true)"
    [ "$code" = 200 ] && break
    sleep 3
  done
  echo "FINAL_${name}_HTTP=$code"
  [ "$code" = 200 ] || exit 70
done

ROM="$ROOT/releases/native/rom/WOOK.gb"
WEB="$ROOT/site/gbstudio/index.html"
ROM_SHA="$(sha256sum "$ROM" | awk '{print $1}')"
WEB_SHA="$(sha256sum "$WEB" | awk '{print $1}')"

# ----------------------------------------------------------------------
# 12 — Final command-to-proof result.
# ----------------------------------------------------------------------
echo "[12/12] FINAL RESULT"
echo "======================================================================"
echo " WOOK C00 // WHERE ARE MY SHOES? // RELEASED"
echo "======================================================================"
echo "STABLE_PLAY_URL=$STABLE_URL"
echo "DIRECT_C00_URL=$DIRECT_URL"
echo "ROM_URL=$ROM_URL"
echo "ROM_SHA256=$ROM_SHA"
echo "WEB_SHA256=$WEB_SHA"
echo "PRODUCTION_HEAD=$PROD_HEAD"
echo "C00_SRL=8"
echo "VISUAL_QA=PASS"
echo "REGRESSION=PASS"
echo "NATIVE_WEB=PASS"
echo "ROM=PASS"
echo "WOOK_C00_RELEASE_PASS"
echo "WOOK_C00_FINAL_COMMAND_TO_PROOF_PASS"
echo "NEXT=C01_GENERAL_ADMISSION"
echo "======================================================================"
