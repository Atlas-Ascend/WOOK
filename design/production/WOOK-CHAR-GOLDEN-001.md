# WOOK-CHAR-GOLDEN-001 — Golden Character Implementation Packet

## Mission

Bind the already-produced WOOK V4 character assets into the already-proven native GB Studio 4.3 project without reopening the toolchain, project migration, hosting, or Golden Campground infrastructure.

## Frozen baseline

The following lanes are not part of this packet:

- Ubuntu / proot installation
- Node 24 installation
- GBDK installation
- GB Studio source checkout
- GB Studio CLI compilation
- GB Studio 3.1 -> 4.x project migration
- Golden Campground background generation
- Git history reconciliation
- GitHack bootstrap

They are inputs.

## Current defect being closed

The native cartridge compiles, but the playable campground does not yet instantiate the character presentation specified by the visual contract.

The project presently uses template sprite resources while WOOK-specific source sprite sheets exist outside the native GB Studio resource body.

## Packet outputs

### Papa Wook

- Native GB Studio sprite resource
- Six-frame locomotion sheet derived from existing Papa Wook production art
- Stable resource ID
- Default TOPDOWN player binding
- Explicit campground-entry sprite binding, which also reactivates the player after the title-screen hide event
- Native avatar resource

### Moonbeam Jessica

- Native GB Studio sprite resource
- Native actor resource in the campground
- Native avatar resource
- Three-page authored interaction with Papa Wook response

### Raccoon

- Native GB Studio sprite resource
- Native campground actor resource
- Native avatar resource
- Encounter introduction
- Four-option native GB Studio menu:
  - Offer snack
  - Intimidate
  - Discuss boundaries
  - Accept loss

### Campground introduction

The previous long single text block is replaced by cartridge-authored pages:

1. `You wake up. / Your Crocs are gone.`
2. `Phone: 17%. / Fantastic.`
3. `Somehow, / this is everyone / else's fault.`

## Resource identity contract

Stable IDs are intentionally deterministic for downstream quests, scripting, receipts, and future art replacement.

```text
Papa Wook sprite     a401bba1-1e10-4a44-9001-000000000001
Jessica sprite       a401bba1-1e10-4a44-9001-000000000002
Raccoon sprite       a401bba1-1e10-4a44-9001-000000000003

Papa avatar          a401bba1-1e10-4a44-9001-000000000101
Jessica avatar       a401bba1-1e10-4a44-9001-000000000102
Raccoon avatar       a401bba1-1e10-4a44-9001-000000000103
```

The visual artwork may evolve without changing these logical identities.

## Build law

The packet executes in this order:

```text
AUDIT EXISTING FACTORY
        ↓
PRESERVE CURRENT PROJECT
        ↓
MATERIALIZE WOOK SPRITE RESOURCES
        ↓
MATERIALIZE AVATAR RESOURCES
        ↓
BIND PAPA AS PLAYER
        ↓
ADD JESSICA ACTOR
        ↓
ADD RACCOON ACTOR + MENU
        ↓
PAGINATE INTRO
        ↓
RESOURCE GRAPH QA
        ↓
GB STUDIO make:web
        ↓
GB STUDIO make:rom
        ↓
PROMOTE NATIVE WEB
        ↓
HASH
        ↓
RECEIPT
        ↓
VISUAL SCREENSHOT QA
```

## Proof levels

### Native implementation proof

`WOOK_CHAR_GOLDEN_NATIVE_PASS`

Requires:

- Papa player resource exists and is bound
- Jessica actor resource exists
- Raccoon actor resource exists
- avatar resources exist
- paginated introduction exists
- native web compiles
- native ROM compiles

### Visual proof

`WOOK_CHARACTER_LEVEL10_PASS`

This is deliberately separate and requires screenshot review against the canonical visual boards with overall character presentation >= 9.0/10.

A successful compiler does not constitute visual Level 10.

## Execution

From a local WOOK checkout on branch `architecture/character-detail-level10`:

```bash
bash scripts/implement-character-golden-001.sh
```

After execution:

```bash
bash scripts/audit-character-golden-001.sh
```

Only after the local native build passes should the implementation commit be pushed and the PR promoted.
