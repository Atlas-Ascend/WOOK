#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${WOOK_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export WOOK_ROOT="$ROOT"
cd "$ROOT"

PACKET="WOOK-C0-GOLDEN-SLICE-001"
STATE_DIR="$ROOT/docs/proof/c0-golden-slice"
STATE_FILE="$STATE_DIR/state.json"
mkdir -p "$STATE_DIR"

GATES=(
  PAPA_WOOK_CONTROLLER SNIFFANY HANDSTAND_DAN RACCOON_ENCOUNTER
  CROCS_0_TO_2 COLLISION_TOPOLOGY HUD PHONE INVENTORY QUEST_LOG
  GROUNDSCORE RESPONSIBILITY WOOK_KARMA SIDE_QUEST SECRET SAVE_RELOAD
  GA_EXIT NATIVE_WEB ROM VISUAL_QA REGRESSION RECEIPT
)

ensure_state() {
  if [ ! -s "$STATE_FILE" ]; then
    jq -n --arg packet "$PACKET" '{schema:"ghost-atlas.wook.c0-golden-slice.state.v1",packet:$packet,phase:"C0_WHERE_ARE_MY_SHOES",gates:{},result:"PENDING"}' > "$STATE_FILE"
  fi
  for gate in "${GATES[@]}"; do
    if ! jq -e --arg g "$gate" '.gates[$g] != null' "$STATE_FILE" >/dev/null 2>&1; then
      tmp="$STATE_FILE.tmp"; jq --arg g "$gate" '.gates[$g]="PENDING"' "$STATE_FILE" > "$tmp"; mv "$tmp" "$STATE_FILE"
    fi
  done
}
set_gate(){ gate="$1"; value="$2"; ensure_state; tmp="$STATE_FILE.tmp"; jq --arg g "$gate" --arg v "$value" '.gates[$g]=$v' "$STATE_FILE" > "$tmp"; mv "$tmp" "$STATE_FILE"; }
first_red_gate(){ ensure_state; for gate in "${GATES[@]}"; do value="$(jq -r --arg g "$gate" '.gates[$g]' "$STATE_FILE")"; [ "$value" = PASS ] || { echo "$gate"; return; }; done; echo NONE; }

cmd_status(){ ensure_state; echo "======================================================================"; echo " WOOK C0 GOLDEN SLICE // STATUS"; echo "======================================================================"; echo "ACTIVE_ROOT=$ROOT"; for gate in "${GATES[@]}"; do printf '%-28s %s\n' "$gate" "$(jq -r --arg g "$gate" '.gates[$g]' "$STATE_FILE")"; done; echo "FIRST_RED_GATE=$(first_red_gate)"; }

cmd_next(){
  gate="$(first_red_gate)"; echo "PACKET=$PACKET"; echo "PHASE=C0_WHERE_ARE_MY_SHOES"; echo "ACTIVE_ROOT=$ROOT"; echo "FIRST_RED_GATE=$gate"
  case "$gate" in
    PAPA_WOOK_CONTROLLER|SNIFFANY|RACCOON_ENCOUNTER) echo "NEXT_ACTION=bash scripts/run-character-golden-001.sh"; echo "MISSION=Prove Papa Wook Sniffany raccoon native layer" ;;
    HANDSTAND_DAN) echo "NEXT_ACTION=bash scripts/resolve-gbstudio-runtime.sh && bash scripts/run-in-active-wook-root.sh scripts/implement-c0-handstand-dan-001.sh" ;;
    CROCS_0_TO_2|COLLISION_TOPOLOGY) echo "NEXT_ACTION=bash scripts/resolve-gbstudio-runtime.sh && bash scripts/run-in-active-wook-root.sh scripts/implement-c0-crocs-collision-001.sh" ;;
    HUD|PHONE|INVENTORY|QUEST_LOG) echo "NEXT_ACTION=bash scripts/run-in-active-wook-root.sh scripts/implement-c0-hud-menu-001.sh"; echo "MISSION=Native contextual HUD and Start Select interface runtime" ;;
    GROUNDSCORE|RESPONSIBILITY|WOOK_KARMA) echo "NEXT_ACTION=bash scripts/run-in-active-wook-root.sh scripts/implement-c0-state-mutations-001.sh"; echo "MISSION=Prove one-time Groundscore Responsibility and Wook Karma interactions" ;;
    SIDE_QUEST) echo "NEXT_ACTION=IMPLEMENT_ONE_COMPLETE_C0_SIDE_QUEST" ;;
    SECRET) echo "NEXT_ACTION=IMPLEMENT_VAN_SECRET_CALLBACK_ITEM" ;;
    SAVE_RELOAD) echo "NEXT_ACTION=RUN_C0_SAVE_RELOAD_MATRIX" ;;
    GA_EXIT) echo "NEXT_ACTION=IMPLEMENT_GA_MAIN_LANE_EXIT_GATE" ;;
    NATIVE_WEB) echo "NEXT_ACTION=PROVE_NATIVE_WEB_FROM_CURRENT_C0_STATE" ;;
    ROM) echo "NEXT_ACTION=PROVE_NATIVE_ROM_FROM_CURRENT_C0_STATE" ;;
    VISUAL_QA) echo "NEXT_ACTION=NATIVE_SCREENSHOT_AND_PLAYTEST_QUALIFICATION" ;;
    REGRESSION) echo "NEXT_ACTION=RUN_C0_REGRESSION_MATRIX" ;;
    RECEIPT) echo "NEXT_ACTION=WRITE_C0_QUALIFICATION_RECEIPT" ;;
    NONE) echo "NEXT_ACTION=QUALIFY_C0_AND_ADVANCE_C1" ;;
  esac
}

cmd_sync(){
  ensure_state
  R="$ROOT/docs/proof/receipts/CHARACTER-GOLDEN-LATEST.json"
  if [ -s "$R" ] && jq -e '.result=="WOOK_CHAR_GOLDEN_NATIVE_PASS"' "$R" >/dev/null 2>&1; then set_gate PAPA_WOOK_CONTROLLER PASS; set_gate SNIFFANY PASS; set_gate RACCOON_ENCOUNTER PASS; echo SYNC_CHARACTER_PACKET=PASS; fi
  R="$ROOT/docs/proof/receipts/C0-HANDSTAND-DAN-LATEST.json"
  if [ -s "$R" ] && jq -e '.result=="WOOK_C0_HANDSTAND_DAN_NATIVE_PASS"' "$R" >/dev/null 2>&1; then set_gate HANDSTAND_DAN PASS; echo SYNC_HANDSTAND_DAN=PASS; fi
  R="$ROOT/docs/proof/receipts/C0-CROCS-COLLISION-LATEST.json"
  if [ -s "$R" ] && jq -e '.result=="WOOK_C0_CROCS_COLLISION_NATIVE_PASS"' "$R" >/dev/null 2>&1; then set_gate CROCS_0_TO_2 PASS; set_gate COLLISION_TOPOLOGY PASS; echo SYNC_CROCS_COLLISION=PASS; fi
  R="$ROOT/docs/proof/receipts/C0-HUD-MENU-LATEST.json"
  if [ -s "$R" ] && jq -e '.result=="WOOK_C0_HUD_MENU_NATIVE_PASS"' "$R" >/dev/null 2>&1; then set_gate HUD PASS; set_gate PHONE PASS; set_gate INVENTORY PASS; set_gate QUEST_LOG PASS; echo SYNC_HUD_MENU=PASS; fi
  R="$ROOT/docs/proof/receipts/C0-STATE-MUTATIONS-LATEST.json"
  if [ -s "$R" ] && jq -e '.result=="WOOK_C0_STATE_MUTATIONS_NATIVE_PASS"' "$R" >/dev/null 2>&1; then set_gate GROUNDSCORE PASS; set_gate RESPONSIBILITY PASS; set_gate WOOK_KARMA PASS; echo SYNC_STATE_MUTATIONS=PASS; fi
  echo "FIRST_RED_GATE=$(first_red_gate)"
}

cmd_run(){
  cmd_sync >/dev/null; gate="$(first_red_gate)"; echo "ACTIVE_ROOT=$ROOT"; echo "RUN_FIRST_RED_GATE=$gate"
  case "$gate" in
    PAPA_WOOK_CONTROLLER|SNIFFANY|RACCOON_ENCOUNTER) WOOK_ROOT="$ROOT" bash scripts/run-character-golden-001.sh ;;
    HANDSTAND_DAN) bash scripts/resolve-gbstudio-runtime.sh; WOOK_ROOT="$ROOT" bash scripts/run-in-active-wook-root.sh scripts/implement-c0-handstand-dan-001.sh ;;
    CROCS_0_TO_2|COLLISION_TOPOLOGY) bash scripts/resolve-gbstudio-runtime.sh; WOOK_ROOT="$ROOT" bash scripts/run-in-active-wook-root.sh scripts/implement-c0-crocs-collision-001.sh ;;
    HUD|PHONE|INVENTORY|QUEST_LOG) WOOK_ROOT="$ROOT" bash scripts/run-in-active-wook-root.sh scripts/implement-c0-hud-menu-001.sh ;;
    GROUNDSCORE|RESPONSIBILITY|WOOK_KARMA) WOOK_ROOT="$ROOT" bash scripts/run-in-active-wook-root.sh scripts/implement-c0-state-mutations-001.sh ;;
    NONE) echo C0_IMPLEMENTED_GATES=COMPLETE ;;
    *) echo "AUTOMATED_PACKET_NOT_YET_INSTANTIATED=$gate"; cmd_next; exit 60 ;;
  esac
  echo; echo "=== EVIDENCE SYNC ==="; cmd_sync; echo "NEXT=$(first_red_gate)"
}

cmd_mark(){ gate="${1:-}"; value="${2:-}"; [ -n "$gate" ] && [ -n "$value" ] || { echo "usage: $0 mark GATE {PASS|FAIL|PENDING}"; exit 2; }; case "$value" in PASS|FAIL|PENDING) ;; *) exit 3;; esac; valid=0; for g in "${GATES[@]}"; do [ "$g" = "$gate" ] && valid=1; done; [ "$valid" -eq 1 ] || exit 4; set_gate "$gate" "$value"; echo "$gate=$value"; echo "FIRST_RED_GATE=$(first_red_gate)"; }

cmd_audit(){
  fail=0
  required=(
    design/production/WOOK-C0-GOLDEN-SLICE-001.md
    design/production/WOOK-C0-HUD-MENU-001.md
    design/production/WOOK-C0-STATE-MUTATIONS-001.md
    design/production/WOOK-SDLC-COMMAND-TO-PROOF.md
    design/gameplay/WOOK-FULL-GAMEPLAY-MAP-BY-MAP.md
    design/systems/WOOK-HUD-STATE-RUNTIME-ARCHITECTURE.md
    design/qa/WOOK-AEROSPACE-GRADE-VERIFICATION-MATRIX.md
    scripts/resolve-gbstudio-runtime.sh scripts/run-in-active-wook-root.sh scripts/run-character-golden-001.sh
    scripts/implement-character-golden-001.sh scripts/implement-c0-handstand-dan-001.sh
    scripts/implement-c0-crocs-collision-001.sh scripts/implement-c0-hud-menu-001.sh
    scripts/audit-c0-hud-menu-001.sh scripts/implement-c0-state-mutations-001.sh
    scripts/audit-c0-state-mutations-001.sh tools/build-c0-hud-menu.py tools/build-c0-state-mutations.py
  )
  echo "ACTIVE_ROOT=$ROOT"
  for f in "${required[@]}"; do if [ -s "$f" ]; then echo "PASS $f"; else echo "FAIL $f"; fail=1; fi; done
  for s in scripts/resolve-gbstudio-runtime.sh scripts/run-in-active-wook-root.sh scripts/run-character-golden-001.sh scripts/implement-character-golden-001.sh scripts/implement-c0-handstand-dan-001.sh scripts/implement-c0-crocs-collision-001.sh scripts/implement-c0-hud-menu-001.sh scripts/audit-c0-hud-menu-001.sh scripts/implement-c0-state-mutations-001.sh scripts/audit-c0-state-mutations-001.sh; do bash -n "$s" || fail=1; echo "SYNTAX_PASS=$s"; done
  python - <<'PY' || fail=1
import ast
from pathlib import Path
for name in ["tools/build-c0-hud-menu.py", "tools/build-c0-state-mutations.py"]:
    ast.parse(Path(name).read_text(), filename=name)
    print(f"PYTHON_SYNTAX_PASS={name}")
PY
  [ "$fail" -eq 0 ] || { echo C0_GOLDEN_SLICE_AUDIT=FAIL; exit 20; }
  echo C0_GOLDEN_SLICE_AUDIT=PASS
}

cmd_receipt(){ ensure_state; gate="$(first_red_gate)"; [ "$gate" = NONE ] || { echo C0_QUALIFICATION=BLOCKED; echo "FIRST_RED_GATE=$gate"; exit 30; }; tmp="$STATE_FILE.tmp"; jq '.result="QUALIFIED"' "$STATE_FILE" > "$tmp"; mv "$tmp" "$STATE_FILE"; cp "$STATE_FILE" "$STATE_DIR/C0-WHERE-ARE-MY-SHOES-QUALIFIED.json"; echo C0_WHERE_ARE_MY_SHOES=QUALIFIED; }

case "${1:-status}" in
  status) cmd_status;; next) cmd_next;; sync) cmd_sync;; run) cmd_run;; mark) cmd_mark "${2:-}" "${3:-}";; audit) cmd_audit;; receipt) cmd_receipt;; *) echo "usage: $0 {status|next|sync|run|audit|mark GATE VALUE|receipt}"; exit 2;;
esac
