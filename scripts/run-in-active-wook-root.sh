#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# Execute an existing WOOK packet against the active checkout selected by the
# controller. Older packets predate safe-checkout support and may contain one
# of a few canonical hard-coded primary-root assignments. We adapt only those
# assignment lines in a temporary copy; the packet's gameplay/build logic is
# otherwise byte-for-byte preserved.

TARGET_SCRIPT="${1:-}"
shift || true

[ -n "$TARGET_SCRIPT" ] || {
  echo "usage: $0 scripts/packet.sh [args...]"
  exit 2
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${WOOK_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export WOOK_ROOT="$ROOT"

case "$TARGET_SCRIPT" in
  /*) SOURCE="$TARGET_SCRIPT" ;;
  *) SOURCE="$ROOT/$TARGET_SCRIPT" ;;
esac

[ -s "$SOURCE" ] || {
  echo "PACKET_SCRIPT=MISSING:$SOURCE"
  exit 10
}

TMP="$(mktemp "$ROOT/scripts/.active-root-packet.XXXXXX.sh")"
cleanup() { rm -f "$TMP"; }
trap cleanup EXIT

sed \
  -e 's|^ROOT="$GA/games/WOOK"$|ROOT="${WOOK_ROOT:-$GA/games/WOOK}"|' \
  -e 's|^WOOK="$GA/games/WOOK"$|WOOK="${WOOK_ROOT:-$GA/games/WOOK}"|' \
  -e 's|^ROOT="$HOME/.ghost-atlas/games/WOOK"$|ROOT="${WOOK_ROOT:-$HOME/.ghost-atlas/games/WOOK}"|' \
  -e 's|^WOOK="$HOME/.ghost-atlas/games/WOOK"$|WOOK="${WOOK_ROOT:-$HOME/.ghost-atlas/games/WOOK}"|' \
  "$SOURCE" > "$TMP"
chmod +x "$TMP"

echo "ACTIVE_WOOK_ROOT=$ROOT"
echo "ADAPTED_PACKET=$TARGET_SCRIPT"

bash "$TMP" "$@"
