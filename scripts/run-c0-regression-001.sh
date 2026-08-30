#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="${WOOK_ROOT:-$(git rev-parse --show-toplevel)}"
GA="$HOME/.ghost-atlas"
PROJECT="$ROOT/game/project/WOOK.gbsproj"
STATE="$ROOT/docs/proof/c0-golden-slice/state.json"
RECEIPTS="$ROOT/docs/proof/receipts"
WEB="$ROOT/releases/native/web"
ROM="$ROOT/releases/native/rom/WOOK.gb"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"

cd "$ROOT"
echo "======================================================================"
echo " WOOK-C0-REGRESSION-001 // GOLDEN CAMPGROUND"
echo "======================================================================"

[ -s "$STATE" ] || { echo "C0_STATE=MISSING"; exit 10; }

# All gates before REGRESSION must be PASS. RECEIPT is intentionally excluded.
pre=(PAPA_WOOK_CONTROLLER SNIFFANY HANDSTAND_DAN RACCOON_ENCOUNTER CROCS_0_TO_2 COLLISION_TOPOLOGY HUD PHONE INVENTORY QUEST_LOG GROUNDSCORE RESPONSIBILITY WOOK_KARMA SIDE_QUEST SECRET SAVE_RELOAD GA_EXIT NATIVE_WEB ROM VISUAL_QA)
for g in "${pre[@]}"; do
  v="$(jq -r --arg g "$g" '.gates[$g]' "$STATE")"
  [ "$v" = PASS ] || { echo "PRECONDITION_${g}=$v"; exit 20; }
done
echo "C0_PRECONDITIONS=PASS"

checks=(
  "CHARACTER-GOLDEN-LATEST.json:WOOK_CHAR_GOLDEN_NATIVE_PASS"
  "C0-HANDSTAND-DAN-LATEST.json:WOOK_C0_HANDSTAND_DAN_NATIVE_PASS"
  "C0-CROCS-COLLISION-LATEST.json:WOOK_C0_CROCS_COLLISION_NATIVE_PASS"
  "C0-HUD-MENU-LATEST.json:WOOK_C0_HUD_MENU_NATIVE_PASS"
  "C0-STATE-MUTATIONS-LATEST.json:WOOK_C0_STATE_MUTATIONS_NATIVE_PASS"
  "C0-SIDE-QUEST-LATEST.json:WOOK_C0_SIDE_QUEST_NATIVE_PASS"
  "C0-SECRET-LATEST.json:WOOK_C0_SECRET_NATIVE_PASS"
  "C0-SAVE-RELOAD-LATEST.json:WOOK_C0_SAVE_RELOAD_NATIVE_PATH_PASS"
  "C0-GA-EXIT-LATEST.json:WOOK_C0_GA_EXIT_NATIVE_PASS"
)
for pair in "${checks[@]}"; do
  f="${pair%%:*}"; expected="${pair#*:}"
  p="$RECEIPTS/$f"
  [ -s "$p" ] || { echo "RECEIPT_MISSING=$f"; exit 21; }
  jq -e --arg e "$expected" '.result==$e' "$p" >/dev/null || { echo "RECEIPT_RESULT_FAIL=$f"; exit 22; }
  echo "RECEIPT_PASS=$f"
done

# Re-run static subsystem audits against the integrated project body.
audits=(
 scripts/audit-character-golden-001.sh
 scripts/audit-c0-handstand-dan-001.sh
 scripts/audit-c0-crocs-collision-001.sh
 scripts/audit-c0-hud-menu-001.sh
 scripts/audit-c0-state-mutations-001.sh
 scripts/audit-c0-side-quest-001.sh
 scripts/audit-c0-secret-001.sh
 scripts/audit-c0-save-reload-001.sh
 scripts/audit-c0-ga-exit-001.sh
)
for a in "${audits[@]}"; do
  [ -s "$a" ] || { echo "AUDIT_SCRIPT_MISSING=$a"; exit 23; }
  bash "$a"
  echo "REGRESSION_AUDIT_PASS=$a"
done

# C01 may exist as an entry seam only. C00 cannot qualify it.
MAN="$ROOT/docs/proof/C0-GA-EXIT-MANIFEST.json"
jq -e '.target_truth=="C01_ENTRY_SEAM_ONLY" and .c01_qualified==false' "$MAN" >/dev/null || { echo "C01_TRUTH_GUARD=FAIL"; exit 24; }
echo "C01_TRUTH_GUARD=PASS"

bash "$ROOT/scripts/resolve-gbstudio-runtime.sh"
rm -rf "$WEB"
mkdir -p "$WEB" "$(dirname "$ROM")"
rm -f "$ROM"
proot-distro login ubuntu \
 --shared-tmp \
 --bind "$GA:/root/.ghost-atlas" \
 --bind "$ROOT:/root/WOOK-CURRENT" \
 -- /bin/bash -s <<'INNER'
set -Eeuo pipefail
ROOT=/root/WOOK-CURRENT
PROJECT="$ROOT/game/project/WOOK.gbsproj"
WEB="$ROOT/releases/native/web"
ROM="$ROOT/releases/native/rom/WOOK.gb"
gb-studio-cli make:web "$PROJECT" "$WEB"
test -s "$WEB/index.html"
echo "REGRESSION_NATIVE_WEB=PASS"
gb-studio-cli make:rom "$PROJECT" "$ROM"
test -s "$ROM"
echo "REGRESSION_NATIVE_ROM=PASS"
INNER

rm -rf "$ROOT/site/gbstudio"
mkdir -p "$ROOT/site/gbstudio"
cp -a "$WEB/." "$ROOT/site/gbstudio/"
ROM_SHA="$(sha256sum "$ROM" | awk '{print $1}')"
WEB_SHA="$(sha256sum "$ROOT/site/gbstudio/index.html" | awk '{print $1}')"

R="$RECEIPTS/WOOK-C0-REGRESSION-001-$STAMP.json"
jq -n --arg ts "$STAMP" --arg rom "$ROM_SHA" --arg web "$WEB_SHA" '{
 schema:"ghost-atlas.wook.c0.regression-proof.v1",
 packet:"WOOK-C0-REGRESSION-001",
 timestamp:$ts,
 proof:{prior_gates:"PASS",receipt_chain:"PASS",static_regression:"PASS",c01_truth_guard:"PASS",integrated_native_web:"PASS",integrated_native_rom:"PASS"},
 hashes:{rom:$rom,native_web:$web},
 result:"WOOK_C0_REGRESSION_PASS"
}' > "$R"
cp "$R" "$RECEIPTS/C0-REGRESSION-LATEST.json"
cat "$R"
echo "WOOK_C0_REGRESSION_PASS"
echo "NEXT=RECEIPT"
