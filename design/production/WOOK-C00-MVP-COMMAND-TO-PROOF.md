# WOOK C00 — COMMAND-TO-PROOF ROM MVP

Packet: `WOOK-C00-MVP-COMMAND-TO-PROOF-001`
Chapter: `C00 — WHERE ARE MY SHOES?`

## Mission

Produce one exact, playable, commit-pinned Game Boy MVP of the complete automated C00 Golden Campground state and publish enough evidence to let the player see the actual chapter before final human presentation qualification.

## Two truth states

`WOOK_C00_MVP_ROM_PASS` means:

- every automated C00 gate through `ROM` is PASS;
- a fresh integrated native web build exists;
- a fresh integrated `.gb` exists;
- both are copied into stable C00 MVP release paths;
- hashes are recorded;
- generated C00 native resources and evidence are committed;
- the release commit is pushed and remote equality is proved;
- a commit-pinned playable web URL is emitted.

It does **not** mean final visual qualification has been granted.

`WOOK_C00_RELEASE_PASS` remains the stronger chapter-release state and requires:

- human native visual/playtest review;
- `VISUAL_QA=PASS`;
- integrated C00 regression;
- C00 chapter qualification receipt.

## Stable MVP artifact paths

```text
releases/mvp/c00/rom/WOOK-C00-MVP.gb
releases/mvp/c00/web/
site/c00-mvp/
docs/proof/releases/C00-MVP-LATEST.json
```

## Command

```bash
bash scripts/wook-c00-mvp-command-to-proof.sh
```

## Automated chapter content expected before MVP freeze

- Papa Wook player/controller binding;
- Sniffany;
- Handstand Dan;
- raccoon encounter;
- Crocs 0/2 → 2/2;
- campground collision topology;
- native HUD;
- phone;
- inventory;
- quest log;
- Groundscore;
- Responsibility;
- Wook Karma;
- one complete side quest;
- one callback secret;
- native save/load path;
- Crocs-gated GA exit;
- native web;
- native ROM.

## Command-to-proof chain

```text
AUDIT
  ↓
FIRST-RED C00 MANUFACTURING
  ↓
AUTOMATED PRE-VISUAL GATES PASS
  ↓
FRESH make:web
  ↓
FRESH make:rom
  ↓
FREEZE MVP ARTIFACTS
  ↓
SHA-256
  ↓
BUILD RECEIPT
  ↓
COMMIT
  ↓
REBASE IF REMOTE ADVANCED
  ↓
PUSH
  ↓
REMOTE SHA EQUALITY
  ↓
COMMIT-PINNED GITHACK HTTP PROOF
  ↓
PUBLICATION RECEIPT
  ↓
WOOK_C00_MVP_ROM_PASS
```

## Human handoff

The player opens the printed commit-pinned GitHack URL, plays the actual C00 candidate and supplies native screenshots/playtest observations.

After visual approval:

```bash
bash scripts/wook-c0-golden-slice-controller.sh visual PASS "native C00 MVP reviewed"
bash scripts/wook-c0-golden-slice-controller.sh run
```

The controller then performs regression and emits the stronger C00 chapter-release receipt.
