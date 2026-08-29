#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "=== WOOK CANONICAL CAST AUDIT ==="

CANONICAL=(
  "Papa Wook"
  "Train Station"
  "Loki"
  "The Wizard"
  "Bufo D' Clown"
  "Handstand Dan"
  "Sniffany"
)

DEPRECATED=(
  "Moonbeam Jessica"
  "Sage Trevor"
  "Space Dave"
  "Solar Charger Guy"
  "DJ Maybe Greg"
  "Lost Kyle"
  "Vanessa Van Person"
)

# `Trent` is checked separately to avoid incidental substring collisions.

for NAME in "${CANONICAL[@]}"; do
  echo "CANONICAL=$NAME"
done

ACTIVE_PATHS=(
  "game/project"
  "design/characters"
  "design/production"
  "design/quests"
  "design/acts"
)

FAIL=0

for NAME in "${DEPRECATED[@]}"; do
  if grep -RInF \
    --exclude-dir='.git' \
    --exclude='*.receipt*' \
    --exclude='*LEGACY*' \
    --exclude='*MIGRATION*' \
    -- "$NAME" "${ACTIVE_PATHS[@]}" 2>/dev/null; then
      echo "DEPRECATED_ACTIVE_NAME=FAIL:$NAME"
      FAIL=1
  else
      echo "DEPRECATED_ACTIVE_NAME=PASS:$NAME"
  fi
done

if grep -RInE \
  --exclude-dir='.git' \
  --exclude='*.receipt*' \
  --exclude='*LEGACY*' \
  --exclude='*MIGRATION*' \
  '(^|[^A-Za-z])Trent([^A-Za-z]|$)' \
  "${ACTIVE_PATHS[@]}" 2>/dev/null; then
    echo "DEPRECATED_ACTIVE_NAME=FAIL:Trent"
    FAIL=1
else
    echo "DEPRECATED_ACTIVE_NAME=PASS:Trent"
fi

if [ "$FAIL" -ne 0 ]; then
  echo "WOOK_CANONICAL_CAST_AUDIT=FAIL"
  exit 20
fi

echo "WOOK_CANONICAL_CAST_AUDIT=PASS"
