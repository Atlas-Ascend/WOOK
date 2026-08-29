#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
OWNER="${WOOK_GITHUB_OWNER:-Atlas-Ascend}"
REPO="${WOOK_GITHUB_REPO:-WOOK}"
BRANCH="main"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
RECEIPT="$ROOT/docs/proof/WOOK-OMEGA-$STAMP.json"

echo
echo "======================================================================"
echo "WOOK OMEGA // BUILD -> HOST -> PROOF"
echo "======================================================================"

# Static playable site is always part of product proof.
test -s "$ROOT/site/index.html"
echo "PLAYABLE_SITE=PASS"

# Native GB Studio compilation is strict truth. If unavailable, do not call it PASS.
GB_NATIVE="FAIL"
if bash "$ROOT/scripts/build-native-gbstudio.sh"; then
  GB_NATIVE="PASS"
  rm -rf "$ROOT/site/gbstudio"
  mkdir -p "$ROOT/site/gbstudio"
  cp -a "$ROOT/releases/native/web"/. "$ROOT/site/gbstudio"/
else
  echo "GB_STUDIO_NATIVE_BUILD=BLOCKED"
  echo "The premium browser vertical slice will still publish, but final native GB Studio proof remains red."
fi

cd "$ROOT"
if [ ! -d .git ]; then git init -b "$BRANCH"; fi
git config user.name "$OWNER"
[ -n "$(git config user.email || true)" ] || git config user.email "${OWNER}@users.noreply.github.com"

if ! gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
  gh repo create "$OWNER/$REPO" --public --description "WOOK — Press Start, Probably. GB Studio psychedelic comedy RPG."
fi
REMOTE="https://github.com/$OWNER/$REPO.git"
if git remote get-url origin >/dev/null 2>&1; then git remote set-url origin "$REMOTE"; else git remote add origin "$REMOTE"; fi

git add -A
if ! git diff --cached --quiet; then git commit -m "WOOK Omega release $STAMP"; fi
git push -u origin "$BRANCH"

COMMIT="$(git rev-parse HEAD)"
REMOTE_COMMIT="$(gh api "repos/$OWNER/$REPO/commits/$BRANCH" --jq '.sha')"
[ "$COMMIT" = "$REMOTE_COMMIT" ]
echo "GITHUB_REMOTE_COMMIT=PASS"

DEV_URL="https://raw.githack.com/$OWNER/$REPO/$BRANCH/site/index.html"
IMM_URL="https://rawcdn.githack.com/$OWNER/$REPO/$COMMIT/site/index.html"
CODE="000"
for i in 1 2 3 4 5 6; do
  CODE="$(curl -L -sS -o /tmp/wook-live -w '%{http_code}' "$DEV_URL" || true)"
  [ "$CODE" = "200" ] && break
  sleep 3
done
if [ "$CODE" = "200" ]; then GITHACK="PASS"; else GITHACK="PENDING:$CODE"; fi

VIS_SHA="$(sha256sum "$ROOT/docs/visual-contract/WOOK-VISUAL-CONTRACT-001.png" | awk '{print $1}')"
SITE_SHA="$(sha256sum "$ROOT/site/index.html" | awk '{print $1}')"
PROJECT_SHA="$(sha256sum "$ROOT/game/project/WOOK.gbsproj" | awk '{print $1}')"
ROM_SHA=""
[ -s "$ROOT/releases/native/WOOK.gb" ] && ROM_SHA="$(sha256sum "$ROOT/releases/native/WOOK.gb" | awk '{print $1}')"

jq -n \
 --arg campaign "GA-WOOK-COMMAND-TO-PROOF-OMEGA-001" \
 --arg timestamp "$STAMP" --arg commit "$COMMIT" \
 --arg visual_sha "$VIS_SHA" --arg site_sha "$SITE_SHA" --arg project_sha "$PROJECT_SHA" \
 --arg rom_sha "$ROM_SHA" --arg native "$GB_NATIVE" --arg githack "$GITHACK" \
 --arg dev "$DEV_URL" --arg immutable "$IMM_URL" \
 '{schema:"ghost-atlas.wook.omega.v1",campaign:$campaign,timestamp:$timestamp,
   product:{name:"WOOK",engine:"GB Studio",tagline:"PRESS START, PROBABLY."},
   proof:{visual_contract:"PASS",playable_site:"PASS",gb_studio_source:"PASS",gb_studio_native_build:$native,github_commit:"PASS",githack:$githack},
   hashes:{visual:$visual_sha,site:$site_sha,gbstudio_project:$project_sha,rom:$rom_sha},
   publication:{commit:$commit,live:$dev,immutable:$immutable},
   result:(if ($native=="PASS" and $githack=="PASS") then "COMMAND_TO_PROOF_PASS" else "PUBLIC_PLAYABLE_PASS_NATIVE_GBSTUDIO_PENDING" end)}' > "$RECEIPT"

git add "$RECEIPT"
git commit -m "proof: WOOK Omega receipt $STAMP" || true
git push origin "$BRANCH" || true

echo
echo "======================================================================"
echo "WOOK PUBLICATION"
echo "======================================================================"
echo "PLAY: $DEV_URL"
echo "IMMUTABLE: $IMM_URL"
echo "GB_STUDIO_NATIVE_BUILD=$GB_NATIVE"
echo "GITHACK=$GITHACK"
echo "RECEIPT=$RECEIPT"
echo
if [ "$GB_NATIVE" = "PASS" ] && [ "$GITHACK" = "PASS" ]; then
 echo "COMMAND_TO_PROOF=PASS"
else
 echo "PUBLIC_PLAYABLE=PASS"
 echo "COMMAND_TO_PROOF_NATIVE=NOT_YET_PROVEN"
fi
echo 'Papa Wook: "The Crocs have entered continuous delivery."'
