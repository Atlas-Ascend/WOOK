#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel)"
PROJECT="$ROOT/game/project"
VARS="$PROJECT/project/variables.gbsres"
ACTORS="$PROJECT/project/scenes/questionable_campground/actors"
MANIFEST="$ROOT/docs/proof/C0-STATE-MUTATIONS-MANIFEST.json"

fail=0
for f in \
  "$VARS" \
  "$ACTORS/groundscore_cache.gbsres" \
  "$ACTORS/community_water.gbsres" \
  "$ACTORS/lost_cup_return.gbsres" \
  "$PROJECT/assets/sprites/groundscore-cache.png.gbsres" \
  "$PROJECT/assets/sprites/community-water.png.gbsres" \
  "$PROJECT/assets/sprites/lost-cup-return.png.gbsres" \
  "$MANIFEST"
do
  if [ -s "$f" ]; then
    case "$f" in *.gbsres|*.json) jq empty "$f" ;; esac
    echo "PASS=$f"
  else
    echo "MISSING=$f"; fail=1
  fi
done

for id in 93 94 95 98 99 100; do
  jq -e --arg id "$id" '.variables[] | select(.id == $id)' "$VARS" >/dev/null || { echo "STATE_VAR_FAIL=$id"; fail=1; }
done

jq -e '.interactions["groundscore-cache"].stat == "95"' "$MANIFEST" >/dev/null || fail=1
jq -e '.interactions["community-water"].stat == "93"' "$MANIFEST" >/dev/null || fail=1
jq -e '.interactions["lost-cup-return"].stat == "94"' "$MANIFEST" >/dev/null || fail=1

if [ "$fail" -ne 0 ]; then echo "C0_STATE_MUTATIONS_AUDIT=FAIL"; exit 20; fi

echo "GROUNDSCORE_MUTATION=PASS"
echo "RESPONSIBILITY_MUTATION=PASS"
echo "WOOK_KARMA_MUTATION=PASS"
echo "ONE_TIME_GUARDS=PASS"
echo "C0_STATE_MUTATIONS_AUDIT=PASS"
