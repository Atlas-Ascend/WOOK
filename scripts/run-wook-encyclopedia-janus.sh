#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

CAMPAIGN="WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001"
OWNER="Atlas-Ascend"
REPO="WOOK"
BRANCH="architecture/character-detail-level10"
GA="$HOME/.ghost-atlas"
PRIMARY="$GA/games/WOOK"
SAFE="$GA/campaigns/$CAMPAIGN/repo"

command -v git >/dev/null 2>&1 || pkg install -y git
command -v jq >/dev/null 2>&1 || pkg install -y jq

choose_repo() {
  if [ -d "$PRIMARY/.git" ]; then
    cd "$PRIMARY"
    if [ -n "$(git status --porcelain)" ]; then
      echo "PRIMARY_WOOK_DIRTY=YES"
      echo "NON_DESTRUCTIVE_SAFE_CHECKOUT=ACTIVE"
      echo "$SAFE"
      return 0
    fi
    echo "$PRIMARY"
    return 0
  fi
  echo "$PRIMARY"
}

TARGET="$(choose_repo | tail -n1)"
mkdir -p "$(dirname "$TARGET")"

if [ ! -d "$TARGET/.git" ]; then
  git clone "https://github.com/$OWNER/$REPO.git" "$TARGET"
fi

cd "$TARGET"
git fetch origin "$BRANCH"

# A production checkout is expected to accumulate generated project resources,
# receipts, proof state and native artifacts. Preserve those without preventing
# the script/control-plane files from being refreshed from origin.
if [ -n "$(git status --porcelain)" ]; then
  echo "TARGET_DIRTY=YES"
  echo "GENERATED_PRODUCTION_STATE=PRESERVE"
  echo "CONTROL_PLANE_REFRESH=WORKTREE_OVERLAY"

  refresh_paths=(scripts tools design campaigns)
  for p in "${refresh_paths[@]}"; do
    if git cat-file -e "origin/$BRANCH:$p" 2>/dev/null; then
      rm -rf "$p"
      git archive "origin/$BRANCH" "$p" | tar -x -f -
    fi
  done
else
  git switch -C "$BRANCH" "origin/$BRANCH"
fi

# Canonical checkout propagation law: every nested controller operates on the
# selected checkout and never silently jumps back to the primary dirty tree.
export WOOK_ROOT="$PWD"

echo
echo "======================================================================"
echo " WOOK // ENCYCLOPEDIA COMMAND TO PROOF // JANUS"
echo "======================================================================"
echo "REPO=$PWD"
echo "WOOK_ROOT=$WOOK_ROOT"
echo "BRANCH=$(git branch --show-current)"
echo "REMOTE_HEAD=$(git rev-parse origin/$BRANCH)"
echo "LOCAL_HEAD=$(git rev-parse HEAD)"

echo
bash scripts/wook-encyclopedia-controller.sh audit

echo
bash scripts/wook-encyclopedia-controller.sh status

echo
bash scripts/wook-encyclopedia-controller.sh next

case "${1:-status}" in
  status)
    echo "MODE=STATUS_ONLY"
    ;;
  run)
    bash scripts/wook-encyclopedia-controller.sh run
    ;;
  autopilot)
    echo "MODE=AUTOPILOT_FIRST_RED_GATE"
    while true; do
      set +e
      bash scripts/wook-encyclopedia-controller.sh run
      rc=$?
      set -e
      if [ "$rc" -eq 0 ]; then
        red="$(bash scripts/wook-encyclopedia-controller.sh report | jq -r '.first_red')"
        echo "FIRST_RED=$red"
        [ "$red" = "NONE:NONE" ] && break
        continue
      fi
      if [ "$rc" -eq 60 ]; then
        echo "AUTOPILOT=PAUSED_AT_FIRST_MANUAL_OR_IMPLEMENTATION_BOUNDARY"
        bash scripts/wook-encyclopedia-controller.sh next
        break
      fi
      echo "AUTOPILOT=STOPPED_ON_RED_GATE"
      echo "EXIT_CODE=$rc"
      exit "$rc"
    done
    ;;
  *)
    echo "usage: $0 {status|run|autopilot}"
    exit 2
    ;;
esac
