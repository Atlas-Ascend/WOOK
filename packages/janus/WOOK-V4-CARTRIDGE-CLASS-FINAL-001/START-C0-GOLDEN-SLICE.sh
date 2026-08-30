#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

echo "=== WOOK C0 GOLDEN SLICE ==="
required=(
  design/gameplay/WOOK-FULL-GAMEPLAY-MAP-BY-MAP.md
  design/gameplay/C0-CAMPGROUND-TOPOLOGY.json
  design/systems/WOOK-HUD-STATE-RUNTIME-ARCHITECTURE.md
  design/qa/WOOK-AEROSPACE-GRADE-VERIFICATION-MATRIX.md
  design/production/WOOK-SDLC-COMMAND-TO-PROOF.md
  design/production/WOOK-C0-HANDSTAND-DAN-001.md
  design/production/WOOK-C0-CROCS-COLLISION-001.md
)
for f in "${required[@]}"; do
  test -s "$f" || { echo "MISSING=$f"; exit 10; }
done

echo "C0_ARCHITECTURE_INPUTS=PASS"
[ -s scripts/audit-canonical-cast.sh ] && bash scripts/audit-canonical-cast.sh
[ -s scripts/wook-cartridge-class-controller.sh ] && bash scripts/wook-cartridge-class-controller.sh audit || true
[ -s scripts/wook-cartridge-class-controller.sh ] && bash scripts/wook-cartridge-class-controller.sh next || true

echo
echo "C0_COMMITTED_PACKETS:"
echo "01 WOOK-C0-HANDSTAND-DAN-001"
echo "02 WOOK-C0-CROCS-COLLISION-001"
echo
echo "FIRST_UNPROVEN_EXECUTION_GATE=WOOK-C0-HANDSTAND-DAN-001"
echo "RUN_01=bash scripts/implement-c0-handstand-dan-001.sh"
echo "AFTER_01_PROOF_RUN_02=bash scripts/implement-c0-crocs-collision-001.sh"
echo "NEXT_ARCHITECTURE_SEAM=HUD_PHONE_INVENTORY_QUEST_LOG"
echo "C0_STATUS=IN_PRODUCTION_NOT_COMPLETE"
