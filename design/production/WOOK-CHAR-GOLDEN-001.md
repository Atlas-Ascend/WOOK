# WOOK-CHAR-GOLDEN-001 — Golden Character Implementation Packet

## Mission

Bind the already-produced WOOK V4 character assets into the already-proven native GB Studio 4.3 project without reopening the toolchain, project migration, hosting, or Golden Campground infrastructure.

This packet now operates under the **Canonical Cast Law**.

## Canonical Golden Scene cast

- Papa Wook — player
- Sniffany — principal social anchor
- Raccoon — encounter creature, not part of named cast

The previous placeholder identity used for the Golden Scene social anchor is deprecated. Historical source art may be used only as a donor during migration; no new runtime resource, dialogue, quest flag, save key, receipt, UI label or forward-facing filename may use the deprecated identity.

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
- Six-frame locomotion seed derived from existing Papa Wook production art
- Stable resource ID
- Default TOPDOWN player binding
- Explicit campground-entry sprite binding, which also reactivates the player after the title-screen hide event
- Native avatar resource

### Sniffany

- Native GB Studio sprite resource
- Native actor resource in the campground
- Native avatar resource
- authored multi-page interaction with Papa Wook
- stable canonical actor identity
- forward quest-state hooks for 4:00 AM and Ordeal callbacks

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

Stable IDs are deterministic for downstream quests, scripting, receipts, and future art replacement.

```text
Papa Wook sprite     a401bba1-1e10-4a44-9001-000000000001
Sniffany sprite      a401bba1-1e10-4a44-9001-000000000002
Raccoon sprite       a401bba1-1e10-4a44-9001-000000000003

Papa avatar          a401bba1-1e10-4a44-9001-000000000101
Sniffany avatar      a401bba1-1e10-4a44-9001-000000000102
Raccoon avatar       a401bba1-1e10-4a44-9001-000000000103
```

The visual artwork may evolve without changing these logical identities.

## Canonical naming gate

Forward production MUST reject these deprecated placeholder strings when found outside historical/archive/provenance paths:

```text
Moonbeam Jessica
Sage Trevor
Trent
Space Dave
Solar Charger Guy
DJ Maybe Greg
Lost Kyle
Vanessa Van Person
```

There is no automatic one-to-one identity mapping from those placeholders to the new canonical cast.

## Build law

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
ADD SNIFFANY ACTOR
        ↓
ADD RACCOON ACTOR + MENU
        ↓
PAGINATE INTRO
        ↓
CANONICAL NAME AUDIT
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
- Sniffany actor resource exists
- Raccoon actor resource exists
- avatar resources exist
- paginated introduction exists
- no deprecated active character identity exists in the native Golden Scene resource graph
- native web compiles
- native ROM compiles

### Visual proof

`WOOK_CHARACTER_LEVEL10_PASS`

Requires screenshot review against the canonical visual boards with overall character presentation >= 9.0/10.

A successful compiler does not constitute visual Level 10.

## Forward cast sequence

After Papa Wook + Sniffany + Raccoon are visually proven in the Golden Scene:

```text
HANDSTAND DAN
      ↓
TRAIN STATION
      ↓
BUFO D' CLOWN
      ↓
LOKI
      ↓
THE WIZARD
```

Each enters the game through a scene-specific implementation packet rather than being dumped into the campground at once.

## Execution principle

The active implementation script must use canonical runtime identities. Historical donor filenames may be copied/converted during migration, but the resulting native resources must be named and symbolized as Sniffany.

Only after the native build passes should the implementation commit be pushed and the PR promoted.