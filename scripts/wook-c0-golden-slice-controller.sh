#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

ROOT="${WOOK_ROOT:-$HOME/.ghost-atlas/games/WOOK}"
cd "$ROOT"

PACKET="WOOK-C0-GOLDEN-SLICE-001"
STATE_DIR="$ROOT/docs/proof/c0-golden-slice"
STATE_FILE="$STATE_DIR/state.json"
mkdir -p "$STATE_DIR"

GATES=(
  PAPA_WOOK_CONTROLLER
  SNIFFANY
  HANDSTAND_DAN
  RACCOON_ENCOUNTER
  CROCS_0_TO_2
  COLLISION_TOPOLOGY
  HUD
  PHONE
  INVENTORY
  QUEST_LOG
  GROUNDSCORE
  RESPONSIBILITY
  WOOK_KARMA
  SIDE_QUEST
  SECRET
  SAVE_RELOAD
  GA_EXIT
  NATIVE_WEB
  ROM
  VISUAL_QA
  REGRESSION
  RECEIPT
)

ensure_state() {
  if [ ! -s "$STATE_FILE" ]; then
    jq -n --arg packet "$PACKET" '{
      schema:"ghost-atlas.wook.c0-golden-slice.state.v1",
      packet:$packet,
      phase:"C0_WHERE_ARE_MY_SHOES",
      gates:{},
      result:"PENDING"
    }' > "$STATE_FILE"
  fi

  for gate in "${GATES[@]}"; do
    if ! jq -e --arg g "$gate" '.gates[$g] != null' "$STATE_FILE" >/dev/null 2>&1; then
      tmp="$STATE_FILE.tmp"
      jq --arg g "$gate" '.gates[$g]="PENDING"' "$STATE_FILE" > "$tmp"
      mv "$tmp" "$STATE_FILE"
    fi
  done
}

first_red_gate() {
  ensure_state
  for gate in "${GATES[@]}"; do
    value="$(jq -r --arg g "$gate" '.gates[$g]' "$STATE_FILE")"
    if [ "$value" != "PASS" ]; then
      echo "$gate"
      return 0
    fi
  done
  echo "NONE"
}

cmd_status() {
  ensure_state
  echo "======================================================================"
  echo " WOOK C0 GOLDEN SLICE // STATUS"
  echo "======================================================================"
  for gate in "${GATES[@]}"; do
    value="$(jq -r --arg g "$gate" '.gates[$g]' "$STATE_FILE")"
    printf '%-28s %s\n' "$gate" "$value"
  done
  echo "FIRST_RED_GATE=$(first_red_gate)"
}

cmd_next() {
  gate="$(first_red_gate)"
  echo "PACKET=$PACKET"
  echo "PHASE=C0_WHERE_ARE_MY_SHOES"
  echo "FIRST_RED_GATE=$gate"
  case "$gate" in
    PAPA_WOOK_CONTROLLER)
      echo "NEXT_ACTION=bash scripts/implement-character-golden-001.sh"
      echo "MISSION=Bind and prove Papa Wook as the native playable hero"
      ;;
    SNIFFANY)
      echo "NEXT_ACTION=VERIFY_SNIFFANY_NATIVE_ACTOR_AND_DIALOGUE"
      ;;
    HANDSTAND_DAN)
      echo "NEXT_ACTION=IMPLEMENT_HANDSTAND_DAN_C0_ACTOR_AND_CHALLENGE"
      ;;
    RACCOON_ENCOUNTER)
      echo "NEXT_ACTION=VERIFY_RACCOON_NATIVE_ENCOUNTER"
      ;;
    CROCS_0_TO_2)
      echo "NEXT_ACTION=IMPLEMENT_CROCS_QUEST_STATE_MACHINE"
      ;;
    COLLISION_TOPOLOGY)
      echo "NEXT_ACTION=IMPLEMENT_AND_ROUTE_TEST_CAMP_COLLISION"
      ;;
    HUD)
      echo "NEXT_ACTION=IMPLEMENT_EXPLORATION_HUD"
      ;;
    PHONE)
      echo "NEXT_ACTION=IMPLEMENT_PHONE_RUNTIME"
      ;;
    INVENTORY)
      echo "NEXT_ACTION=IMPLEMENT_INVENTORY_RUNTIME"
      ;;
    QUEST_LOG)
      echo "NEXT_ACTION=IMPLEMENT_QUEST_LOG_RUNTIME"
      ;;
    GROUNDSCORE|RESPONSIBILITY|WOOK_KARMA)
      echo "NEXT_ACTION=IMPLEMENT_C0_STATE_MUTATIONS"
      ;;
    SIDE_QUEST)
      echo "NEXT_ACTION=IMPLEMENT_ONE_COMPLETE_C0_SIDE_QUEST"
      ;;
    SECRET)
      echo "NEXT_ACTION=IMPLEMENT_VAN_SECRET_CALLBACK_ITEM"
      ;;
    SAVE_RELOAD)
      echo "NEXT_ACTION=RUN_C0_SAVE_RELOAD_MATRIX"
      ;;
    GA_EXIT)
      echo "NEXT_ACTION=IMPLEMENT_GA_MAIN_LANE_EXIT_GATE"
      ;;
    NATIVE_WEB)
      echo "NEXT_ACTION=gb-studio-cli make:web"
      ;;
    ROM)
      echo "NEXT_ACTION=gb-studio-cli make:rom"
      ;;
    VISUAL_QA)
      echo "NEXT_ACTION=NATIVE_SCREENSHOT_AND_PLAYTEST_QUALIFICATION"
      ;;
    REGRESSION)
      echo "NEXT_ACTION=RUN_C0_REGRESSION_MATRIX"
      ;;
    RECEIPT)
      echo "NEXT_ACTION=WRITE_C0_QUALIFICATION_RECEIPT"
      ;;
    NONE)
      echo "NEXT_ACTION=QUALIFY_C0_AND_ADVANCE_C1"
      ;;
  esac
}

cmd_mark() {
  gate="${1:-}"
  value="${2:-}"
  [ -n "$gate" ] && [ -n "$value" ] || {
    echo "usage: $0 mark GATE {PASS|FAIL|PENDING}"
    exit 2
  }
  case "$value" in PASS|FAIL|PENDING) ;; *) echo "INVALID_VALUE=$value"; exit 3 ;; esac

  valid=0
  for g in "${GATES[@]}"; do [ "$g" = "$gate" ] && valid=1; done
  [ "$valid" -eq 1 ] || { echo "UNKNOWN_GATE=$gate"; exit 4; }

  ensure_state
  tmp="$STATE_FILE.tmp"
  jq --arg g "$gate" --arg v "$value" '.gates[$g]=$v' "$STATE_FILE" > "$tmp"
  mv "$tmp" "$STATE_FILE"
  echo "$gate=$value"
  echo "FIRST_RED_GATE=$(first_red_gate)"
}

cmd_audit() {
  fail=0
  required=(
    design/production/WOOK-C0-GOLDEN-SLICE-001.md
    design/production/WOOK-C0-GOLDEN-SLICE-001.yaml
    design/production/WOOK-SDLC-COMMAND-TO-PROOF.md
    design/gameplay/WOOK-FULL-GAMEPLAY-MAP-BY-MAP.md
    design/systems/WOOK-HUD-STATE-RUNTIME-ARCHITECTURE.md
    design/qa/WOOK-AEROSPACE-GRADE-VERIFICATION-MATRIX.md
  )
  for f in "${required[@]}"; do
    if [ -s "$f" ]; then echo "PASS $f"; else echo "FAIL $f"; fail=1; fi
  done

  if [ -s scripts/implement-character-golden-001.sh ]; then
    bash -n scripts/implement-character-golden-001.sh || fail=1
    echo "CHARACTER_PACKET_PRESENT=PASS"
  else
    echo "CHARACTER_PACKET_PRESENT=FAIL"
    fail=1
  fi

  if [ "$fail" -ne 0 ]; then
    echo "C0_GOLDEN_SLICE_AUDIT=FAIL"
    exit 20
  fi
  echo "C0_GOLDEN_SLICE_AUDIT=PASS"
}

cmd_receipt() {
  ensure_state
  gate="$(first_red_gate)"
  if [ "$gate" != "NONE" ]; then
    echo "C0_QUALIFICATION=BLOCKED"
    echo "FIRST_RED_GATE=$gate"
    exit 30
  fi

  tmp="$STATE_FILE.tmp"
  jq '.result="QUALIFIED"' "$STATE_FILE" > "$tmp"
  mv "$tmp" "$STATE_FILE"
  cp "$STATE_FILE" "$STATE_DIR/C0-WHERE-ARE-MY-SHOES-QUALIFIED.json"
  echo "C0_WHERE_ARE_MY_SHOES=QUALIFIED"
}

case "${1:-status}" in
  status) cmd_status ;;
  next) cmd_next ;;
  mark) cmd_mark "${2:-}" "${3:-}" ;;
  audit) cmd_audit ;;
  receipt) cmd_receipt ;;
  *) echo "usage: $0 {status|next|audit|mark GATE VALUE|receipt}"; exit 2 ;;
esac
