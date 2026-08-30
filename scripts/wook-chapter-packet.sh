#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${WOOK_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export WOOK_ROOT="$ROOT"
CAMPAIGN="$ROOT/campaigns/WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001/campaign.json"
OUT="$ROOT/docs/proof/whole-game/work-packets"
mkdir -p "$OUT"
cd "$ROOT"

command -v jq >/dev/null 2>&1 || { echo "JQ=MISSING"; exit 20; }
test -s "$CAMPAIGN" || {
  echo "CAMPAIGN=MISSING"
  echo "EXPECTED=$CAMPAIGN"
  echo "ACTIVE_ROOT=$ROOT"
  exit 21
}

valid_chapter() {
  jq -e --arg c "$1" '.chapters[]|select(.id==$c)' "$CAMPAIGN" >/dev/null 2>&1
}

prepare() {
  local cid="$1"
  valid_chapter "$cid" || { echo "UNKNOWN_CHAPTER=$cid"; exit 30; }
  local out="$OUT/${cid}-WORK-PACKET.json"
  jq --arg c "$cid" '
    . as $root |
    .chapters[] | select(.id==$c) |
    {
      schema:"ghost-atlas.wook.chapter.work-packet.v1",
      campaign:$root.campaign,
      chapter:.id,
      title:.title,
      mission:.mission,
      maps:.maps,
      gates:$root.default_gates,
      required_roles:["R02","R03","R04","R05","R07","R10","R11","R12","R13","R14","R16","R17","R19"],
      lifecycle:["EXPERIENCE_BRIEF","REQUIREMENTS","MAP_SPEC","STATE_CONTRACT","ART_AUDIO_CONTRACT","IMPLEMENTATION","STATIC_VALIDATION","NATIVE_BUILD","INTEGRATION","FAILURE_TEST","PRESENTATION_QA","SAVE_RELOAD","REGRESSION","HASH","RECEIPT"],
      readiness_target:"SRL-8 minimum before chapter qualification",
      truth:"PREPARED_NOT_IMPLEMENTED_UNLESS_NATIVE_EVIDENCE_EXISTS"
    }' "$CAMPAIGN" > "$out"
  echo "ACTIVE_ROOT=$ROOT"
  echo "WORK_PACKET=$out"
  jq . "$out"
}

show() {
  local cid="$1" f="$OUT/${cid}-WORK-PACKET.json"
  [ -s "$f" ] || prepare "$cid" >/dev/null
  cat "$f"
}

audit() {
  local cid="$1" f="$OUT/${cid}-WORK-PACKET.json"
  [ -s "$f" ] || { echo "WORK_PACKET=MISSING"; exit 40; }
  jq -e '.schema=="ghost-atlas.wook.chapter.work-packet.v1" and (.gates|length)==16 and (.required_roles|length)>=13' "$f" >/dev/null || { echo "WORK_PACKET_INVALID"; exit 41; }
  echo "CHAPTER_WORK_PACKET_AUDIT=PASS"
  echo "CHAPTER=$cid"
  echo "ACTIVE_ROOT=$ROOT"
}

case "${1:-}" in
  prepare) [ -n "${2:-}" ] || { echo "usage: $0 prepare C00"; exit 2; }; prepare "$2" ;;
  show) [ -n "${2:-}" ] || exit 2; show "$2" ;;
  audit) [ -n "${2:-}" ] || exit 2; audit "$2" ;;
  *) echo "usage: $0 {prepare|show|audit} C00..C15"; exit 2 ;;
esac
