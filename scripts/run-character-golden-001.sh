#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

ROOT="${WOOK_ROOT:-$HOME/.ghost-atlas/games/WOOK}"
cd "$ROOT"

echo "======================================================================"
echo " WOOK C0 // CHARACTER GATE ENTRYPOINT"
echo "======================================================================"

bash scripts/resolve-gbstudio-runtime.sh

echo "CHARACTER_RUNTIME_PREFLIGHT=PASS"
echo

exec bash scripts/implement-character-golden-001.sh
