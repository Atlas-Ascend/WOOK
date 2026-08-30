#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$ROOT" ]; then
  echo "WOOK_REPO=NOT_FOUND"
  exit 10
fi
cd "$ROOT"

BRANCH="architecture/character-detail-level10"
BASELINE="51f909b1f24fddf10c391100256e9cdbda28fb1b"

echo "=== WOOK JANUS IN-REPO PACKAGE ==="
echo "ROOT=$ROOT"
echo "BRANCH=$(git branch --show-current)"
echo "HEAD=$(git rev-parse HEAD)"

if [ -n "$(git status --porcelain)" ]; then
  echo "WORKTREE_DIRTY=YES"
  echo "ACTION=ABORT_TO_PRESERVE_LOCAL_WORK"
  exit 20
fi

git fetch origin "$BRANCH"
git switch "$BRANCH"
git pull --ff-only origin "$BRANCH"

if ! git merge-base --is-ancestor "$BASELINE" HEAD; then
  echo "PACKAGE_BASELINE_PRESENT=FAIL"
  exit 30
fi

echo "PACKAGE_BASELINE_PRESENT=PASS"

required=(
  design/production/WOOK-CARTRIDGE-CLASS-FINAL-PACKAGE.md
  design/production/WOOK-SDLC-COMMAND-TO-PROOF.md
  design/gameplay/WOOK-FULL-GAMEPLAY-MAP-BY-MAP.md
  design/systems/WOOK-HUD-STATE-RUNTIME-ARCHITECTURE.md
  design/qa/WOOK-AEROSPACE-GRADE-VERIFICATION-MATRIX.md
  design/platform/WOOK-ROM-PLATFORM-UPGRADE-ADR.md
  design/characters/CANONICAL-CAST-LAW.md
  design/characters/WOOKIE-RESERVE-ROSTER.md
)
for f in "${required[@]}"; do
  test -s "$f" || { echo "MISSING=$f"; exit 40; }
done
echo "MASTER_PACKAGE_AUDIT=PASS"

[ -s scripts/audit-canonical-cast.sh ] && bash scripts/audit-canonical-cast.sh
[ -s scripts/wook-cartridge-class-controller.sh ] && bash scripts/wook-cartridge-class-controller.sh audit
[ -s scripts/wook-cartridge-class-controller.sh ] && bash scripts/wook-cartridge-class-controller.sh next

echo "JANUS_REPO_PACKAGE=PASS"
echo "NEXT=WOOK-C0-GOLDEN-SLICE-001"
