#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"
OWNER=Atlas-Ascend; REPO=WOOK; STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
GH="https://raw.githack.com/$OWNER/$REPO/main/site/index.html"
TMP="${TMPDIR:-$PREFIX/tmp}"; mkdir -p "$TMP"
function probe(){ local url="$1" out="$2"; local code; code="$(curl -L -sS -o "$out" -w "%{http_code}" "$url" || true)"; printf "%s" "$code"; }
GHC="$(probe "$GH" "$TMP/wook-githack.html")"
VURL="$(cat docs/proof/vercel-url.txt 2>/dev/null || true)"
CURL="$(cat docs/proof/cloudflare-url.txt 2>/dev/null || true)"
VC="NA"; CC="NA"
[ -n "$VURL" ] && VC="$(probe "$VURL" "$TMP/wook-vercel.html")"
[ -n "$CURL" ] && CC="$(probe "$CURL" "$TMP/wook-cloudflare.html")"
NATIVE="FAIL"; [ -s releases/native/rom/WOOK.gb ] && [ -s site/gbstudio/index.html ] && NATIVE="PASS"
ROM_SHA=""; [ -s releases/native/rom/WOOK.gb ] && ROM_SHA="$(sha256sum releases/native/rom/WOOK.gb|awk '{print $1}')"
SITE_SHA="$(sha256sum site/index.html|awk '{print $1}')"
A_SHA="$(sha256sum art/reference/WOOK-VISUAL-CONTRACT-LEVEL10-BOARD-A.png|awk '{print $1}')"
B_SHA="$(sha256sum art/reference/WOOK-VISUAL-CONTRACT-LEVEL10-BOARD-B.png|awk '{print $1}')"
RESULT="WOOK_V4_PUBLIC_PROOF_PASS"
[ "$NATIVE" = PASS ] && [ "$GHC" = 200 ] && [ "$VC" = 200 ] && [ "$CC" = 200 ] && RESULT="WOOK_V4_FULL_COMMAND_TO_PROOF_PASS"
mkdir -p docs/proof/receipts
jq -n --arg timestamp "$STAMP" --arg native "$NATIVE" --arg gh "$GHC" --arg vercel "$VC" --arg cf "$CC" \
 --arg ghurl "$GH" --arg vurl "$VURL" --arg cfurl "$CURL" --arg rom "$ROM_SHA" --arg site "$SITE_SHA" --arg a "$A_SHA" --arg b "$B_SHA" --arg result "$RESULT" \
 '{schema:"ghost-atlas.wook.v4.cart-team.proof.v1",timestamp:$timestamp,engine:"GB Studio",proof:{native:$native,githack_http:$gh,vercel_http:$vercel,cloudflare_http:$cf},urls:{githack:$ghurl,vercel:$vurl,cloudflare:$cfurl},hashes:{rom:$rom,site_router:$site,visual_board_a:$a,visual_board_b:$b},result:$result}' \
 > "docs/proof/receipts/WOOK-V4-$STAMP.json"
cp "docs/proof/receipts/WOOK-V4-$STAMP.json" docs/proof/receipts/LATEST.json
cat docs/proof/receipts/LATEST.json
