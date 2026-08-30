#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

echo "=== WOOK C0 GOLDEN SLICE ==="

required=(
  design/gameplay/WOOK-FULL-GAMEPLAY-MAP-BY-MAP.md
  design/systems/WOOK-HUD-STATE-RUNTIME-ARCHITECTURE.md
  design/qa/WOOK-AEROSPACE-GRADE-VERIFICATION-MATRIX.md
  design/production/WOOK-SDLC-COMMAND-TO-PROOF.md
)
for f in "${required[@]}"; do
  test -s "$f" || { echo "MISSING=$f"; exit 10; }
done

echo "C0_ARCHITECTURE_INPUTS=PASS"
[ -s scripts/audit-canonical-cast.sh ] && bash scripts/audit-canonical-cast.sh
[ -s scripts/wook-cartridge-class-controller.sh ] && bash scripts/wook-cartridge-class-controller.sh audit || true
[ -s scripts/wook-cartridge-class-controller.sh ] && bash scripts/wook-cartridge-class-controller.sh next || true

echo "NEXT_CHARACTER_PACKET=WOOK-C0-HANDSTAND-DAN-001"
echo "RUN_WHEN_READY=bash scripts/implement-c0-handstand-dan-001.sh"
echo "C0_STATUS=IN_PRODUCTION_NOT_COMPLETE"
