#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${WOOK_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export WOOK_ROOT="$ROOT"
cd "$ROOT"

PACKET="WOOK-C0-GOLDEN-SLICE-001"
STATE_DIR="$ROOT/docs/proof/c0-golden-slice"
STATE_FILE="$STATE_DIR/state.json"
RECEIPTS="$ROOT/docs/proof/receipts"
CHAPTER_RECEIPTS="$ROOT/docs/proof/chapters"
mkdir -p "$STATE_DIR" "$RECEIPTS" "$CHAPTER_RECEIPTS"

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
      tmp="$STATE_FILE.tmp"
      jq --arg g "$gate" '.gates[$g]="PENDING"' "$STATE_FILE" > "$tmp"
      mv "$tmp" "$STATE_FILE"
    fi
  done
}

set_gate() {
  local gate="$1" value="$2" tmp
  ensure_state
  tmp="$STATE_FILE.tmp"
  jq --arg g "$gate" --arg v "$value" '.gates[$g]=$v' "$STATE_FILE" > "$tmp"
  mv "$tmp" "$STATE_FILE"
}

get_gate() {
  ensure_state
  jq -r --arg g "$1" '.gates[$g]' "$STATE_FILE"
}

first_red_gate() {
  ensure_state
  local gate value
  for gate in "${GATES[@]}"; do
    value="$(get_gate "$gate")"
    [ "$value" = PASS ] || { echo "$gate"; return 0; }
  done
  echo NONE
}

cmd_status() {
  ensure_state
  echo "======================================================================"
  echo " WOOK C0 GOLDEN SLICE // STATUS"
  echo "======================================================================"
  echo "ACTIVE_ROOT=$ROOT"
  for gate in "${GATES[@]}"; do
    printf '%-28s %s\n' "$gate" "$(get_gate "$gate")"
  done
  echo "FIRST_RED_GATE=$(first_red_gate)"
  echo "RESULT=$(jq -r '.result' "$STATE_FILE")"
}

cmd_next() {
  local gate
  gate="$(first_red_gate)"
  echo "PACKET=$PACKET"
  echo "PHASE=C0_WHERE_ARE_MY_SHOES"
  echo "ACTIVE_ROOT=$ROOT"
  echo "FIRST_RED_GATE=$gate"
  case "$gate" in
    PAPA_WOOK_CONTROLLER|SNIFFANY|RACCOON_ENCOUNTER)
      echo "NEXT_ACTION=bash scripts/run-character-golden-001.sh"
      echo "MISSION=Prove Papa Wook Sniffany raccoon native layer" ;;
    HANDSTAND_DAN)
      echo "NEXT_ACTION=bash scripts/resolve-gbstudio-runtime.sh && bash scripts/run-in-active-wook-root.sh scripts/implement-c0-handstand-dan-001.sh" ;;
    CROCS_0_TO_2|COLLISION_TOPOLOGY)
      echo "NEXT_ACTION=bash scripts/resolve-gbstudio-runtime.sh && bash scripts/run-in-active-wook-root.sh scripts/implement-c0-crocs-collision-001.sh" ;;
    HUD|PHONE|INVENTORY|QUEST_LOG)
      echo "NEXT_ACTION=bash scripts/run-in-active-wook-root.sh scripts/implement-c0-hud-menu-001.sh" ;;
    GROUNDSCORE|RESPONSIBILITY|WOOK_KARMA)
      echo "NEXT_ACTION=bash scripts/run-in-active-wook-root.sh scripts/implement-c0-state-mutations-001.sh" ;;
    SIDE_QUEST)
      echo "NEXT_ACTION=bash scripts/run-in-active-wook-root.sh scripts/implement-c0-side-quest-001.sh" ;;
    SECRET)
      echo "NEXT_ACTION=bash scripts/run-in-active-wook-root.sh scripts/implement-c0-secret-001.sh" ;;
    SAVE_RELOAD)
      echo "NEXT_ACTION=bash scripts/run-in-active-wook-root.sh scripts/implement-c0-save-reload-001.sh" ;;
    GA_EXIT)
      echo "NEXT_ACTION=bash scripts/run-in-active-wook-root.sh scripts/implement-c0-ga-exit-001.sh" ;;
    NATIVE_WEB|ROM)
      echo "NEXT_ACTION=SYNC_FROM_LATEST_C0_NATIVE_BUILD" ;;
    VISUAL_QA)
      echo "NEXT_ACTION=PLAY_NATIVE_C0_AND_CAPTURE_SCREENSHOT"
      echo "AFTER_REVIEW=bash scripts/wook-c0-golden-slice-controller.sh visual PASS \"review note\"" ;;
    REGRESSION)
      echo "NEXT_ACTION=bash scripts/run-c0-regression-001.sh" ;;
    RECEIPT)
      echo "NEXT_ACTION=bash scripts/wook-c0-golden-slice-controller.sh receipt" ;;
    NONE)
      echo "NEXT_ACTION=ADVANCE_C01_GENERAL_ADMISSION" ;;
  esac
}

sync_result() {
  local file="$1" expected="$2" gate="$3" label="$4"
  if [ -s "$file" ] && jq -e --arg e "$expected" '.result==$e' "$file" >/dev/null 2>&1; then
    set_gate "$gate" PASS
    echo "$label=PASS"
    return 0
  fi
  return 1
}

cmd_sync() {
  ensure_state
  local R

  R="$RECEIPTS/CHARACTER-GOLDEN-LATEST.json"
  if [ -s "$R" ] && jq -e '.result=="WOOK_CHAR_GOLDEN_NATIVE_PASS"' "$R" >/dev/null 2>&1; then
    set_gate PAPA_WOOK_CONTROLLER PASS
    set_gate SNIFFANY PASS
    set_gate RACCOON_ENCOUNTER PASS
    echo SYNC_CHARACTER_PACKET=PASS
  fi

  sync_result "$RECEIPTS/C0-HANDSTAND-DAN-LATEST.json" "WOOK_C0_HANDSTAND_DAN_NATIVE_PASS" HANDSTAND_DAN SYNC_HANDSTAND_DAN || true

  R="$RECEIPTS/C0-CROCS-COLLISION-LATEST.json"
  if [ -s "$R" ] && jq -e '.result=="WOOK_C0_CROCS_COLLISION_NATIVE_PASS"' "$R" >/dev/null 2>&1; then
    set_gate CROCS_0_TO_2 PASS
    set_gate COLLISION_TOPOLOGY PASS
    echo SYNC_CROCS_COLLISION=PASS
  fi

  R="$RECEIPTS/C0-HUD-MENU-LATEST.json"
  if [ -s "$R" ] && jq -e '.result=="WOOK_C0_HUD_MENU_NATIVE_PASS"' "$R" >/dev/null 2>&1; then
    set_gate HUD PASS
    set_gate PHONE PASS
    set_gate INVENTORY PASS
    set_gate QUEST_LOG PASS
    echo SYNC_HUD_MENU=PASS
  fi

  R="$RECEIPTS/C0-STATE-MUTATIONS-LATEST.json"
  if [ -s "$R" ] && jq -e '.result=="WOOK_C0_STATE_MUTATIONS_NATIVE_PASS"' "$R" >/dev/null 2>&1; then
    set_gate GROUNDSCORE PASS
    set_gate RESPONSIBILITY PASS
    set_gate WOOK_KARMA PASS
    echo SYNC_STATE_MUTATIONS=PASS
  fi

  sync_result "$RECEIPTS/C0-SIDE-QUEST-LATEST.json" "WOOK_C0_SIDE_QUEST_NATIVE_PASS" SIDE_QUEST SYNC_SIDE_QUEST || true
  sync_result "$RECEIPTS/C0-SECRET-LATEST.json" "WOOK_C0_SECRET_NATIVE_PASS" SECRET SYNC_SECRET || true
  sync_result "$RECEIPTS/C0-SAVE-RELOAD-LATEST.json" "WOOK_C0_SAVE_RELOAD_NATIVE_PATH_PASS" SAVE_RELOAD SYNC_SAVE_RELOAD_NATIVE_PATH || true

  R="$RECEIPTS/C0-GA-EXIT-LATEST.json"
  if [ -s "$R" ] && jq -e '.result=="WOOK_C0_GA_EXIT_NATIVE_PASS"' "$R" >/dev/null 2>&1; then
    set_gate GA_EXIT PASS
    set_gate NATIVE_WEB PASS
    set_gate ROM PASS
    echo SYNC_GA_EXIT=PASS
    echo SYNC_NATIVE_WEB=PASS
    echo SYNC_ROM=PASS
  fi

  R="$RECEIPTS/C0-VISUAL-QA-LATEST.json"
  if [ -s "$R" ]; then
    case "$(jq -r '.result // ""' "$R")" in
      WOOK_C0_VISUAL_QA_PASS) set_gate VISUAL_QA PASS; echo SYNC_VISUAL_QA=PASS ;;
      WOOK_C0_VISUAL_QA_FAIL) set_gate VISUAL_QA FAIL; echo SYNC_VISUAL_QA=FAIL ;;
    esac
  fi

  sync_result "$RECEIPTS/C0-REGRESSION-LATEST.json" "WOOK_C0_REGRESSION_PASS" REGRESSION SYNC_REGRESSION || true

  if [ -s "$CHAPTER_RECEIPTS/C00-LATEST.json" ] && jq -e '.result=="WOOK_C00_RELEASE_PASS"' "$CHAPTER_RECEIPTS/C00-LATEST.json" >/dev/null 2>&1; then
    set_gate RECEIPT PASS
    tmp="$STATE_FILE.tmp"
    jq '.result="QUALIFIED"' "$STATE_FILE" > "$tmp"
    mv "$tmp" "$STATE_FILE"
    echo SYNC_C00_RELEASE_RECEIPT=PASS
  fi

  echo "FIRST_RED_GATE=$(first_red_gate)"
}

cmd_run() {
  cmd_sync >/dev/null
  local gate
  gate="$(first_red_gate)"
  echo "ACTIVE_ROOT=$ROOT"
  echo "RUN_FIRST_RED_GATE=$gate"
  case "$gate" in
    PAPA_WOOK_CONTROLLER|SNIFFANY|RACCOON_ENCOUNTER)
      WOOK_ROOT="$ROOT" bash scripts/run-character-golden-001.sh ;;
    HANDSTAND_DAN)
      bash scripts/resolve-gbstudio-runtime.sh
      WOOK_ROOT="$ROOT" bash scripts/run-in-active-wook-root.sh scripts/implement-c0-handstand-dan-001.sh ;;
    CROCS_0_TO_2|COLLISION_TOPOLOGY)
      bash scripts/resolve-gbstudio-runtime.sh
      WOOK_ROOT="$ROOT" bash scripts/run-in-active-wook-root.sh scripts/implement-c0-crocs-collision-001.sh ;;
    HUD|PHONE|INVENTORY|QUEST_LOG)
      WOOK_ROOT="$ROOT" bash scripts/run-in-active-wook-root.sh scripts/implement-c0-hud-menu-001.sh ;;
    GROUNDSCORE|RESPONSIBILITY|WOOK_KARMA)
      WOOK_ROOT="$ROOT" bash scripts/run-in-active-wook-root.sh scripts/implement-c0-state-mutations-001.sh ;;
    SIDE_QUEST)
      WOOK_ROOT="$ROOT" bash scripts/run-in-active-wook-root.sh scripts/implement-c0-side-quest-001.sh ;;
    SECRET)
      WOOK_ROOT="$ROOT" bash scripts/run-in-active-wook-root.sh scripts/implement-c0-secret-001.sh ;;
    SAVE_RELOAD)
      WOOK_ROOT="$ROOT" bash scripts/run-in-active-wook-root.sh scripts/implement-c0-save-reload-001.sh ;;
    GA_EXIT)
      WOOK_ROOT="$ROOT" bash scripts/run-in-active-wook-root.sh scripts/implement-c0-ga-exit-001.sh ;;
    NATIVE_WEB|ROM)
      cmd_sync ;;
    VISUAL_QA)
      echo "AUTOPILOT=PAUSED_FOR_HUMAN_VISUAL_QA"
      cmd_next
      exit 60 ;;
    REGRESSION)
      WOOK_ROOT="$ROOT" bash scripts/run-c0-regression-001.sh ;;
    RECEIPT)
      cmd_receipt ;;
    NONE)
      echo C0_GOLDEN_SLICE=QUALIFIED ;;
    *)
      echo "AUTOMATED_PACKET_NOT_YET_INSTANTIATED=$gate"
      cmd_next
      exit 60 ;;
  esac
  echo
  echo "=== EVIDENCE SYNC ==="
  cmd_sync
  echo "NEXT=$(first_red_gate)"
}

cmd_visual() {
  local verdict="${1:-}" note="${2:-native screenshot reviewed}"
  case "$verdict" in PASS|FAIL) ;; *) echo "usage: $0 visual {PASS|FAIL} \"review note\""; exit 2 ;; esac
  local rom="$ROOT/releases/native/rom/WOOK.gb" web="$ROOT/site/gbstudio/index.html" stamp commit romsha websha result out
  [ -s "$rom" ] || { echo "ROM=MISSING"; exit 30; }
  [ -s "$web" ] || { echo "NATIVE_WEB=MISSING"; exit 31; }
  stamp="$(date -u +%Y%m%dT%H%M%SZ)"
  commit="$(git rev-parse HEAD)"
  romsha="$(sha256sum "$rom" | awk '{print $1}')"
  websha="$(sha256sum "$web" | awk '{print $1}')"
  [ "$verdict" = PASS ] && result="WOOK_C0_VISUAL_QA_PASS" || result="WOOK_C0_VISUAL_QA_FAIL"
  out="$RECEIPTS/WOOK-C0-VISUAL-QA-$stamp.json"
  jq -n --arg ts "$stamp" --arg verdict "$verdict" --arg note "$note" --arg commit "$commit" --arg rom "$romsha" --arg web "$websha" --arg result "$result" '{schema:"ghost-atlas.wook.c0.visual-qa.v1",timestamp:$ts,verdict:$verdict,note:$note,commit:$commit,hashes:{rom:$rom,native_web:$web},review_type:"HUMAN_NATIVE_SCREENSHOT_PLAYTEST_REVIEW",result:$result}' > "$out"
  cp "$out" "$RECEIPTS/C0-VISUAL-QA-LATEST.json"
  set_gate VISUAL_QA "$verdict"
  cat "$out"
  echo "VISUAL_QA=$verdict"
  echo "FIRST_RED_GATE=$(first_red_gate)"
}

cmd_mark() {
  local gate="${1:-}" value="${2:-}"
  [ -n "$gate" ] && [ -n "$value" ] || { echo "usage: $0 mark GATE {PASS|FAIL|PENDING}"; exit 2; }
  case "$value" in PASS|FAIL|PENDING) ;; *) exit 3 ;; esac
  local valid=0 g
  for g in "${GATES[@]}"; do [ "$g" = "$gate" ] && valid=1; done
  [ "$valid" -eq 1 ] || exit 4
  if [ "$gate" = VISUAL_QA ] && [ "$value" = PASS ]; then
    echo "USE_VISUAL_RECEIPT_COMMAND=bash $0 visual PASS \"review note\""
    exit 5
  fi
  set_gate "$gate" "$value"
  echo "$gate=$value"
  echo "FIRST_RED_GATE=$(first_red_gate)"
}

cmd_audit() {
  local fail=0 f s
  local required=(
    design/production/WOOK-C0-GOLDEN-SLICE-001.md
    design/production/WOOK-C0-HUD-MENU-001.md
    design/production/WOOK-C0-STATE-MUTATIONS-001.md
    design/production/WOOK-C0-SIDE-QUEST-001.md
    design/production/WOOK-C0-SECRET-001.md
    design/production/WOOK-C0-SAVE-RELOAD-001.md
    design/production/WOOK-C0-GA-EXIT-001.md
    design/qa/WOOK-C0-REGRESSION-001.md
    design/production/WOOK-SDLC-COMMAND-TO-PROOF.md
    design/gameplay/WOOK-FULL-GAMEPLAY-MAP-BY-MAP.md
    design/systems/WOOK-HUD-STATE-RUNTIME-ARCHITECTURE.md
    design/qa/WOOK-AEROSPACE-GRADE-VERIFICATION-MATRIX.md
    scripts/resolve-gbstudio-runtime.sh
    scripts/run-in-active-wook-root.sh
    scripts/run-character-golden-001.sh
    scripts/implement-character-golden-001.sh
    scripts/audit-character-golden-001.sh
    scripts/implement-c0-handstand-dan-001.sh
    scripts/implement-c0-crocs-collision-001.sh
    scripts/implement-c0-hud-menu-001.sh
    scripts/audit-c0-hud-menu-001.sh
    scripts/implement-c0-state-mutations-001.sh
    scripts/audit-c0-state-mutations-001.sh
    scripts/implement-c0-side-quest-001.sh
    scripts/audit-c0-side-quest-001.sh
    scripts/implement-c0-secret-001.sh
    scripts/audit-c0-secret-001.sh
    scripts/implement-c0-save-reload-001.sh
    scripts/audit-c0-save-reload-001.sh
    scripts/implement-c0-ga-exit-001.sh
    scripts/audit-c0-ga-exit-001.sh
    scripts/run-c0-regression-001.sh
    tools/build-c0-hud-menu.py
    tools/build-c0-state-mutations.py
    tools/build-c0-side-quest.py
    tools/build-c0-secret.py
    tools/build-c0-save-reload.py
    tools/build-c0-ga-exit.py
  )
  echo "ACTIVE_ROOT=$ROOT"
  for f in "${required[@]}"; do
    if [ -s "$f" ]; then echo "PASS $f"; else echo "FAIL $f"; fail=1; fi
  done
  for s in scripts/*.sh; do
    case "$s" in
      scripts/implement-*|scripts/audit-*|scripts/run-*|scripts/resolve-*|scripts/wook-c0-golden-slice-controller.sh)
        bash -n "$s" || fail=1 ;;
    esac
  done
  python - <<'PY' || fail=1
import ast
from pathlib import Path
for name in [
 "tools/build-c0-hud-menu.py","tools/build-c0-state-mutations.py","tools/build-c0-side-quest.py",
 "tools/build-c0-secret.py","tools/build-c0-save-reload.py","tools/build-c0-ga-exit.py"
]:
    ast.parse(Path(name).read_text(), filename=name)
    print(f"PYTHON_SYNTAX_PASS={name}")
PY
  [ "$fail" -eq 0 ] || { echo C0_GOLDEN_SLICE_AUDIT=FAIL; exit 20; }
  echo C0_GOLDEN_SLICE_AUDIT=PASS
}

cmd_receipt() {
  ensure_state
  local g v tmp stamp commit rom web romsha websha out
  for g in "${GATES[@]}"; do
    [ "$g" = RECEIPT ] && continue
    v="$(get_gate "$g")"
    [ "$v" = PASS ] || { echo "C0_QUALIFICATION=BLOCKED"; echo "FIRST_RED_GATE=$g"; exit 40; }
  done
  rom="$ROOT/releases/native/rom/WOOK.gb"
  web="$ROOT/site/gbstudio/index.html"
  [ -s "$rom" ] || { echo ROM=MISSING; exit 41; }
  [ -s "$web" ] || { echo NATIVE_WEB=MISSING; exit 42; }
  stamp="$(date -u +%Y%m%dT%H%M%SZ)"
  commit="$(git rev-parse HEAD)"
  romsha="$(sha256sum "$rom" | awk '{print $1}')"
  websha="$(sha256sum "$web" | awk '{print $1}')"
  set_gate RECEIPT PASS
  tmp="$STATE_FILE.tmp"
  jq --arg ts "$stamp" --arg commit "$commit" --arg rom "$romsha" --arg web "$websha" '.result="QUALIFIED" | .qualified_at=$ts | .qualified_commit=$commit | .hashes={rom:$rom,native_web:$web}' "$STATE_FILE" > "$tmp"
  mv "$tmp" "$STATE_FILE"
  cp "$STATE_FILE" "$STATE_DIR/C0-WHERE-ARE-MY-SHOES-QUALIFIED.json"
  out="$CHAPTER_RECEIPTS/C00-LATEST.json"
  jq -n --arg ts "$stamp" --arg commit "$commit" --arg rom "$romsha" --arg web "$websha" '{schema:"ghost-atlas.wook.chapter.release.v1",chapter:"C00",title:"WHERE ARE MY SHOES?",timestamp:$ts,commit:$commit,srl:8,proof:{all_c0_gates:"PASS",visual_qa:"PASS",regression:"PASS",native_web:"PASS",native_rom:"PASS"},hashes:{rom:$rom,native_web:$web},result:"WOOK_C00_RELEASE_PASS"}' > "$out"
  echo "C00_CHAPTER_RECEIPT=$out"
  echo "C0_WHERE_ARE_MY_SHOES=QUALIFIED"
  echo "NEXT=C01_GENERAL_ADMISSION"
}

case "${1:-status}" in
  status) cmd_status ;;
  next) cmd_next ;;
  sync) cmd_sync ;;
  run) cmd_run ;;
  visual) cmd_visual "${2:-}" "${3:-native screenshot reviewed}" ;;
  mark) cmd_mark "${2:-}" "${3:-}" ;;
  audit) cmd_audit ;;
  receipt) cmd_receipt ;;
  *) echo "usage: $0 {status|next|sync|run|visual PASS|FAIL note|audit|mark GATE VALUE|receipt}"; exit 2 ;;
esac
