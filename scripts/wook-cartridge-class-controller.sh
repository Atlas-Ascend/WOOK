#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

ROOT="${WOOK_ROOT:-$HOME/.ghost-atlas/games/WOOK}"
cd "$ROOT"

PHASES=(
  C0_WHERE_ARE_MY_SHOES
  C1_GENERAL_ADMISSION
  C2_THROUGH_THE_GATES
  C3_LIT_FAMILY_REUNION_DAY_ONE
  C4_AFTER_THE_SHOW
  C5_ALTERNATE_REALITY
  C6_0400_AM
  C7_THE_ORDEAL
  C8_DAY_TWO_MASTERY
  C9_NIGHT_TWO
  C10_FINAL_FESTIVAL_DAY
  C11_THE_LAST_NIGHT
  C12_PACK_DOWN_GOODBYES
  C13_THE_ROAD_HOME
  C14_COSMIC_JOURNEY
  C15_OH
)

GATES=(
  REQUIREMENTS
  ARCHITECTURE
  RESOURCE_VALIDATION
  NATIVE_COMPILE
  FUNCTIONAL_TEST
  FAILURE_MODE_TEST
  PRESENTATION_QA
  REGRESSION
  ARTIFACT_HASH
  RELEASE_RECEIPT
)

STATE_DIR="$ROOT/docs/proof/chapter-state"
mkdir -p "$STATE_DIR"

cmd_status() {
  echo "=============================================================="
  echo " WOOK V4 — CARTRIDGE CLASS // CHAPTER STATUS"
  echo "=============================================================="
  for phase in "${PHASES[@]}"; do
    receipt="$STATE_DIR/$phase.json"
    if [ -s "$receipt" ] && jq -e '.result == "QUALIFIED"' "$receipt" >/dev/null 2>&1; then
      printf '%-38s %s\n' "$phase" "QUALIFIED"
    else
      printf '%-38s %s\n' "$phase" "PENDING"
    fi
  done
}

cmd_next() {
  for phase in "${PHASES[@]}"; do
    receipt="$STATE_DIR/$phase.json"
    if ! { [ -s "$receipt" ] && jq -e '.result == "QUALIFIED"' "$receipt" >/dev/null 2>&1; }; then
      echo "NEXT_PHASE=$phase"
      case "$phase" in
        C0_WHERE_ARE_MY_SHOES)
          echo "NEXT_PACKET=WOOK-C0-GOLDEN-SLICE-001"
          echo "MISSION=Qualify the complete Golden Campground gameplay slice"
          ;;
        *)
          echo "NEXT_PACKET=NOT_YET_INSTANTIATED"
          echo "MISSION=Instantiate phase packet from master gameplay + SDLC contracts"
          ;;
      esac
      return 0
    fi
  done
  echo "NEXT_PHASE=NONE"
  echo "FULL_GAME=QUALIFIED"
}

cmd_gates() {
  echo "REQUIRED_GATES:"
  for gate in "${GATES[@]}"; do
    echo "  - $gate"
  done
}

cmd_audit() {
  echo "=== MASTER PACKAGE AUDIT ==="
  required=(
    design/production/WOOK-CARTRIDGE-CLASS-FINAL-PACKAGE.md
    design/production/WOOK-CARTRIDGE-CLASS-FINAL-001.yaml
    design/production/WOOK-SDLC-COMMAND-TO-PROOF.md
    design/gameplay/WOOK-FULL-GAMEPLAY-MAP-BY-MAP.md
    design/systems/WOOK-HUD-STATE-RUNTIME-ARCHITECTURE.md
    design/qa/WOOK-AEROSPACE-GRADE-VERIFICATION-MATRIX.md
    design/platform/WOOK-ROM-PLATFORM-UPGRADE-ADR.md
    design/characters/CANONICAL-CAST-LAW.md
    design/characters/WOOKIE-RESERVE-ROSTER.md
  )
  fail=0
  for file in "${required[@]}"; do
    if [ -s "$file" ]; then
      echo "PASS $file"
    else
      echo "FAIL $file"
      fail=1
    fi
  done

  if [ -x scripts/audit-canonical-cast.sh ]; then
    bash scripts/audit-canonical-cast.sh || fail=1
  fi

  if [ -s releases/native/rom/WOOK.gb ]; then
    echo "ROM_BASELINE=PASS"
    echo "ROM_SHA256=$(sha256sum releases/native/rom/WOOK.gb | awk '{print $1}')"
  else
    echo "ROM_BASELINE=NOT_PRESENT_LOCAL"
  fi

  if [ "$fail" -ne 0 ]; then
    echo "MASTER_PACKAGE_AUDIT=FAIL"
    exit 20
  fi
  echo "MASTER_PACKAGE_AUDIT=PASS"
}

cmd_receipt_template() {
  phase="${1:-}"
  [ -n "$phase" ] || { echo "usage: $0 receipt-template PHASE"; exit 2; }
  valid=0
  for p in "${PHASES[@]}"; do [ "$p" = "$phase" ] && valid=1; done
  [ "$valid" -eq 1 ] || { echo "UNKNOWN_PHASE=$phase"; exit 3; }

  jq -n --arg phase "$phase" '{
    schema:"wook.chapter.qualification.v1",
    phase:$phase,
    gates:{
      requirements:"PENDING",
      architecture:"PENDING",
      resource_validation:"PENDING",
      native_compile:"PENDING",
      functional_test:"PENDING",
      failure_mode_test:"PENDING",
      presentation_qa:"PENDING",
      regression:"PENDING",
      artifact_hash:"PENDING",
      release_receipt:"PENDING"
    },
    result:"PENDING"
  }'
}

case "${1:-status}" in
  status) cmd_status ;;
  next) cmd_next ;;
  gates) cmd_gates ;;
  audit) cmd_audit ;;
  receipt-template) cmd_receipt_template "${2:-}" ;;
  *)
    echo "usage: $0 {status|next|gates|audit|receipt-template PHASE}"
    exit 2
    ;;
esac
