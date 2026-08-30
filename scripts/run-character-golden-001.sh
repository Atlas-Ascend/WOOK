#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${WOOK_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export WOOK_ROOT="$ROOT"
cd "$ROOT"

echo "======================================================================"
echo " WOOK C0 // CHARACTER GATE ENTRYPOINT"
echo "======================================================================"
echo "ACTIVE_ROOT=$ROOT"

bash scripts/resolve-gbstudio-runtime.sh

echo "CHARACTER_RUNTIME_PREFLIGHT=PASS"
echo

exec bash scripts/run-in-active-wook-root.sh scripts/implement-character-golden-001.sh
