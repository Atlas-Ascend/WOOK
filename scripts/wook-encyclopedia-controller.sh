#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# Resolve the repository from the script location unless the caller explicitly
# provides WOOK_ROOT. This makes safe/non-destructive checkouts first-class and
# prevents nested controllers from silently jumping to the primary dirty tree.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${WOOK_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export WOOK_ROOT="$ROOT"

CAMPAIGN="$ROOT/campaigns/WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001/campaign.json"
STATE_DIR="$ROOT/docs/proof/whole-game"
STATE="$STATE_DIR/state.json"
mkdir -p "$STATE_DIR"
cd "$ROOT"

command -v jq >/dev/null 2>&1 || { echo "JQ=MISSING"; exit 20; }
test -s "$CAMPAIGN" || {
  echo "CAMPAIGN_MANIFEST=MISSING"
  echo "EXPECTED=$CAMPAIGN"
  echo "ACTIVE_ROOT=$ROOT"
  exit 21
}

ensure_state() {
  if [ ! -s "$STATE" ]; then
    jq '{schema:"ghost-atlas.wook.whole-game.state.v1",campaign:.campaign,result:"PENDING",chapters:(.chapters|map({key:.id,value:{title:.title,status:"PENDING",srl:2,gates:{}}})|from_entries)}' "$CAMPAIGN" > "$STATE"
  fi

  while IFS= read -r cid; do
    while IFS= read -r gate; do
      if ! jq -e --arg c "$cid" --arg g "$gate" '.chapters[$c].gates[$g] != null' "$STATE" >/dev/null 2>&1; then
        tmp="$STATE.tmp"
        jq --arg c "$cid" --arg g "$gate" '.chapters[$c].gates[$g]="PENDING"' "$STATE" > "$tmp"
        mv "$tmp" "$STATE"
      fi
    done < <(jq -r '.default_gates[]' "$CAMPAIGN")
  done < <(jq -r '.chapters[].id' "$CAMPAIGN")
}

set_chapter_gate() {
  local cid="$1" gate="$2" value="$3"
  ensure_state
  local tmp="$STATE.tmp"
  jq --arg c "$cid" --arg g "$gate" --arg v "$value" '.chapters[$c].gates[$g]=$v' "$STATE" > "$tmp"
  mv "$tmp" "$STATE"
}

qualify_chapter_from_receipt() {
  local cid="$1" srl="${2:-8}"
  ensure_state
  local tmp="$STATE.tmp"
  jq --arg c "$cid" --argjson s "$srl" '.chapters[$c].status="QUALIFIED" | .chapters[$c].srl=$s | .chapters[$c].gates |= with_entries(.value="PASS")' "$STATE" > "$tmp"
  mv "$tmp" "$STATE"
}

sync_evidence() {
  ensure_state

  local c0="$ROOT/docs/proof/c0-golden-slice/state.json"
  if [ -s "$c0" ] && jq -e '.result == "QUALIFIED"' "$c0" >/dev/null 2>&1; then
    qualify_chapter_from_receipt C00 8
    echo "SYNC_C00=QUALIFIED"
  fi

  while IFS= read -r cid; do
    [ "$cid" = "C00" ] && continue
    local r="$ROOT/docs/proof/chapters/${cid}-LATEST.json"
    if [ -s "$r" ] && jq -e --arg expected "WOOK_${cid}_RELEASE_PASS" '.result == $expected' "$r" >/dev/null 2>&1; then
      qualify_chapter_from_receipt "$cid" 8
      echo "SYNC_${cid}=QUALIFIED"
    fi
  done < <(jq -r '.chapters[].id' "$CAMPAIGN")
}

first_red() {
  ensure_state
  while IFS= read -r cid; do
    local status
    status="$(jq -r --arg c "$cid" '.chapters[$c].status' "$STATE")"
    if [ "$status" != "QUALIFIED" ]; then
      while IFS= read -r gate; do
        local v
        v="$(jq -r --arg c "$cid" --arg g "$gate" '.chapters[$c].gates[$g]' "$STATE")"
        if [ "$v" != "PASS" ]; then
          echo "$cid:$gate"
          return 0
        fi
      done < <(jq -r '.default_gates[]' "$CAMPAIGN")
      echo "$cid:RECEIPT"
      return 0
    fi
  done < <(jq -r '.chapters[].id' "$CAMPAIGN")
  echo "NONE:NONE"
}

cmd_audit() {
  local fail=0
  local required=(
    design/encyclopedia/ENCYCLOPEDIA-OF-WOOK.md
    design/encyclopedia/C0-C15-COMPLETE-GAME.md
    design/production/19-ROLE-PRODUCTION-ORGANISM.md
    design/production/WOOK-END-TO-END-PRODUCTION-LAW.md
    design/qa/WOOK-WHOLE-GAME-RELEASE-QUALIFICATION.md
    campaigns/WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001/campaign.json
    scripts/wook-encyclopedia-controller.sh
    scripts/wook-chapter-packet.sh
  )

  echo "=== WOOK ENCYCLOPEDIA AUDIT ==="
  echo "ACTIVE_ROOT=$ROOT"
  for f in "${required[@]}"; do
    if [ -s "$f" ]; then echo "PASS $f"; else echo "FAIL $f"; fail=1; fi
  done

  local roles chapters
  roles="$(jq '.roles|length' "$CAMPAIGN")"
  chapters="$(jq '.chapters|length' "$CAMPAIGN")"
  echo "ROLE_COUNT=$roles"
  echo "CHAPTER_COUNT=$chapters"
  [ "$roles" -eq 19 ] || fail=1
  [ "$chapters" -eq 16 ] || fail=1

  bash -n scripts/wook-encyclopedia-controller.sh || fail=1
  bash -n scripts/wook-chapter-packet.sh || fail=1

  if [ "$fail" -ne 0 ]; then
    echo "WOOK_ENCYCLOPEDIA_AUDIT=FAIL"
    exit 30
  fi
  echo "WOOK_ENCYCLOPEDIA_AUDIT=PASS"
}

cmd_status() {
  sync_evidence >/dev/null || true
  ensure_state
  echo "======================================================================"
  echo " WOOK // ENCYCLOPEDIA COMMAND TO PROOF"
  echo "======================================================================"
  echo "ACTIVE_ROOT=$ROOT"
  while IFS= read -r cid; do
    local title status srl
    title="$(jq -r --arg c "$cid" '.chapters[$c].title' "$STATE")"
    status="$(jq -r --arg c "$cid" '.chapters[$c].status' "$STATE")"
    srl="$(jq -r --arg c "$cid" '.chapters[$c].srl' "$STATE")"
    printf '%-4s  %-34s  %-10s SRL-%s\n' "$cid" "$title" "$status" "$srl"
  done < <(jq -r '.chapters[].id' "$CAMPAIGN")
  echo "FIRST_RED=$(first_red)"
}

cmd_next() {
  sync_evidence >/dev/null || true
  local red cid gate
  red="$(first_red)"; cid="${red%%:*}"; gate="${red#*:}"
  if [ "$cid" = "NONE" ]; then
    echo "NEXT=WHOLE_GAME_RELEASE_QUALIFICATION"
    return 0
  fi
  echo "NEXT_CHAPTER=$cid"
  echo "NEXT_GATE=$gate"
  jq -r --arg c "$cid" '.chapters[]|select(.id==$c)|"TITLE="+.title,"MISSION="+.mission,"MAPS="+(.maps|join(" | "))' "$CAMPAIGN"
  echo "PRIMARY_ROLES=R02,R03,R04,R05,R07,R10,R11,R12,R13,R14,R16,R17,R19"
  echo "PACKET_COMMAND=bash scripts/wook-chapter-packet.sh prepare $cid"
}

cmd_run() {
  sync_evidence >/dev/null || true
  local red cid gate
  red="$(first_red)"; cid="${red%%:*}"; gate="${red#*:}"
  echo "RUN_CHAPTER=$cid"
  echo "RUN_GATE=$gate"

  if [ "$cid" = "NONE" ]; then
    echo "CHAPTER_TRAIN=QUALIFIED"
    echo "NEXT=bash scripts/wook-encyclopedia-controller.sh prove"
    return 0
  fi

  if [ "$cid" = "C00" ]; then
    WOOK_ROOT="$ROOT" bash scripts/wook-c0-golden-slice-controller.sh run
    sync_evidence || true
    echo "FIRST_RED=$(first_red)"
    return 0
  fi

  local impl="scripts/implement-${cid,,}.sh"
  if [ -x "$impl" ] || [ -s "$impl" ]; then
    WOOK_ROOT="$ROOT" bash "$impl"
    sync_evidence || true
    echo "FIRST_RED=$(first_red)"
    return 0
  fi

  WOOK_ROOT="$ROOT" bash scripts/wook-chapter-packet.sh prepare "$cid"
  echo "IMPLEMENTATION_PACKET_REQUIRED=$cid"
  echo "TRUTH=ARCHITECTURE_READY_NATIVE_IMPLEMENTATION_NOT_YET_PROVEN"
  exit 60
}

cmd_report() {
  sync_evidence >/dev/null || true
  ensure_state
  jq --arg red "$(first_red)" '. + {first_red:$red,active_root:"'"$ROOT"'"}' "$STATE"
}

cmd_prove() {
  sync_evidence >/dev/null || true
  ensure_state
  local red
  red="$(first_red)"
  [ "$red" = "NONE:NONE" ] || { echo "WHOLE_GAME_PROOF=BLOCKED"; echo "FIRST_RED=$red"; exit 70; }

  local whole="$STATE_DIR/WHOLE-GAME-REGRESSION.json"
  [ -s "$whole" ] || { echo "WHOLE_GAME_REGRESSION_EVIDENCE=MISSING"; exit 71; }
  jq -e '.result == "PASS"' "$whole" >/dev/null || { echo "WHOLE_GAME_REGRESSION=FAIL"; exit 72; }

  local rom="$ROOT/releases/native/rom/WOOK.gb"
  local web="$ROOT/site/gbstudio/index.html"
  [ -s "$rom" ] || { echo "ROM=MISSING"; exit 73; }
  [ -s "$web" ] || { echo "NATIVE_WEB=MISSING"; exit 74; }

  local stamp romsha websha commit receipt
  stamp="$(date -u +%Y%m%dT%H%M%SZ)"
  romsha="$(sha256sum "$rom" | awk '{print $1}')"
  websha="$(sha256sum "$web" | awk '{print $1}')"
  commit="$(git rev-parse HEAD)"
  receipt="$STATE_DIR/WOOK-WHOLE-GAME-RELEASE-$stamp.json"

  jq -n --arg campaign "WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001" --arg ts "$stamp" --arg commit "$commit" --arg rom "$romsha" --arg web "$websha" '{schema:"ghost-atlas.wook.whole-game.release.v1",campaign:$campaign,timestamp:$ts,release_commit:$commit,hashes:{rom:$rom,native_web:$web},proof:{all_chapters_srl8_plus:"PASS",whole_game_regression:"PASS",native_web:"PASS",rom:"PASS"},result:"WOOK_CARTRIDGE_CLASS_RELEASE_PASS"}' > "$receipt"
  cp "$receipt" "$STATE_DIR/LATEST.json"
  echo "WHOLE_GAME_RECEIPT=$receipt"
  echo "ROM_SHA256=$romsha"
  echo "WEB_SHA256=$websha"
  echo "WOOK_CARTRIDGE_CLASS_RELEASE_PASS"
}

case "${1:-status}" in
  audit) cmd_audit ;;
  status) cmd_status ;;
  next) cmd_next ;;
  sync) sync_evidence ;;
  run) cmd_run ;;
  report) cmd_report ;;
  prove) cmd_prove ;;
  *) echo "usage: $0 {audit|status|next|sync|run|report|prove}"; exit 2 ;;
esac
