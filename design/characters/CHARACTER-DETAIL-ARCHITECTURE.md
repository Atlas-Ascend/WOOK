# WOOK V4 — Character Detail Architecture

**Campaign:** GA-WOOK-V4-CHARACTER-DETAIL-001  
**Baseline:** WOOK V4 native GB Studio 4.3.2 build is already proven.  
**Status:** active cartridge-class character architecture.  
**Purpose:** increase character fidelity to commercial Game Boy / Nintendo-era craftsmanship without rebuilding the proven toolchain.

---

## 1. Canonical named cast

Active named production identities:

```text
PAPA WOOK
TRAIN STATION
LOKI
THE WIZARD
BUFO D' CLOWN
HANDSTAND DAN
SNIFFANY
```

Additional names are introduced only intentionally.

Supporting roles remain functional/unnamed until promoted into canon.

Deprecated placeholder identities are provenance-only and are forbidden in new dialogue, quests, runtime resources, save keys, UI labels and active production filenames.

There is **no automatic one-to-one mapping** from a deprecated placeholder to a canonical character.

---

## 2. Architectural law

Character quality is a layered presentation system:

```text
CHARACTER IDENTITY
    ↓
SILHOUETTE GRAMMAR
    ↓
OVERWORLD SPRITE FAMILY
    ↓
ANIMATION FAMILY
    ↓
PORTRAIT FAMILY
    ↓
CONTEXTUAL POSES
    ↓
DIALOGUE / ENCOUNTER PRESENTATION
    ↓
GB STUDIO RESOURCE BINDING
    ↓
NATIVE BUILD
    ↓
VISUAL QA
```

No character is complete because one PNG exists.

A character is complete only when the presentation layers are authored, bound into the GB Studio resource graph, exercised in a native scene, compiled into web + ROM, and visually verified against the canonical WOOK boards.

---

## 3. Fidelity tiers

### Tier A — Hero

**Papa Wook**

Required:
- four-direction locomotion
- four-direction idle
- turn frames
- contextual poses
- item-acquisition pose
- phone pose
- campfire sit
- confusion reaction
- dance loop
- negotiation pose
- exhausted pose
- victory pose
- 8+ dialogue portraits
- late-game animation variation

### Tier B — Principal NPCs

- Train Station
- Loki
- The Wizard
- Bufo D' Clown
- Handstand Dan
- Sniffany

Required:
- unmistakable silhouette
- movement set appropriate to role
- 2–5 contextual poses
- 4+ portraits
- one signature animation
- scene-specific staging
- at least one recurring-state callback

### Tier C — Supporting roles

Examples:
- festival staff
- camp neighbors
- vendors
- security
- crowd performers
- vehicle occupants

Required:
- one strong silhouette
- role-readable accessory
- minimal but deliberate animation
- functional role label unless intentionally promoted into named canon

### Tier D — Creature / Encounter

Examples:
- raccoon
- environmental creatures

Required:
- strong silhouette
- idle motion
- reaction motion
- dedicated encounter composition where appropriate
- non-generic interaction verbs

---

## 4. Pixel-density doctrine

The weakness being corrected is insufficient authored information per frame, not simply sprite size.

Overworld frames must communicate the identity anchors that matter most.

Priority order:

1. silhouette
2. face framing
3. headwear / hair / beard
4. primary clothing mass
5. signature prop
6. hands / gesture
7. secondary clothing texture
8. micro-detail

Tiny details that destroy silhouette clarity are rejected.

---

## 5. Papa Wook master grammar

Mandatory identity anchors:
- broad hat mass
- rounded sunglasses
- full beard mass
- layered outerwear
- small utility pack
- slightly wide grounded stance
- compact expressive arm gestures

### Motion arc

Early game:
- loose timing
- asymmetric idle
- small secondary bob

Late game:
- deliberate cadence
- cleaner stance
- same comic warmth

The hero visually changes through confidence and rhythm, not through becoming a different design.

---

## 6. Canonical principal-NPC differentiation

| Character | Silhouette | Signature motion | Production function |
|---|---|---|---|
| Papa Wook | hat + beard + pack | loose-to-grounded walk | hero |
| Train Station | travel/utility mass | route-point / hurry / wait | threshold + logistics |
| Loki | asymmetric sharp silhouette | grin / misdirect / exit | trickster + alternate-reality hinge |
| The Wizard | tall vertical mystic shape | profound stillness / revelation | mentor + pattern recognition |
| Bufo D' Clown | unmistakable performer shape | prop gag / bow / performance | spectacle + clown prophet |
| Handstand Dan | upright + inverted silhouette family | handstand / wobble / recover | physical comedy + skill challenge |
| Sniffany | distinct hair/headwear + accessory | skeptical lean / amused reaction | recurring social anchor |
| Raccoon | compact masked body + tail | alert / snack / retreat | creature encounter |

No two principal characters may share an unmodified silhouette family.

---

## 7. Native GB Studio resource architecture

```text
art/source/characters/
        ↓
production export
        ↓
game/project/assets/sprites/
        ↓
PNG + PNG.gbsres
        ↓
stable GB Studio resource ID
        ↓
player / actor resource
        ↓
scene scripts + animation state
        ↓
native web + WOOK.gb
```

Required native symbols:

```text
sprite_papa_wook
sprite_train_station
sprite_loki
sprite_the_wizard
sprite_bufo_d_clown
sprite_handstand_dan
sprite_sniffany
sprite_raccoon
```

Stable logical resource IDs should survive visual replacement whenever possible.

---

## 8. Source architecture

```text
art/source/characters/
├── papa-wook/
├── train-station/
├── loki/
├── the-wizard/
├── bufo-d-clown/
├── handstand-dan/
└── sniffany/
```

Each principal directory should ultimately contain:

```text
model-sheet/
silhouette/
overworld/
portraits/
context-poses/
exports/
```

Native-ready assets live separately in:

```text
game/project/assets/sprites/
game/project/assets/avatars/
```

Legacy donor art may be used during migration, but native output must use canonical production identity.

---

## 9. Player architecture

Papa Wook is the native player body, not a decorative actor.

Every playable scene must verify:
- player active
- player visible
- Papa Wook sprite assigned
- valid spawn
- valid facing
- no collision trap

The title scene may hide/deactivate the player, but gameplay entry must restore him explicitly.

---

## 10. Dialogue and portrait architecture

Principal dialogue pattern:

```text
PORTRAIT
NAME
1–3 authored lines
ADVANCE
```

Long prose is paginated manually.

The dialogue box is part of timing and performance.

### Golden Scene first principal dialogue

```text
SNIFFANY

Oh my god.
You finally woke up.
```

Advance.

```text
PAPA WOOK

Define "finally."
```

Sniffany becomes the first principal NPC used to validate recurring social-character presentation beside Papa Wook.

---

## 11. Signature character systems

### Train Station
- route guidance
- threshold timing
- meetup logic
- venue-gate appearances
- road-home callback

### Loki
- side-quest branching
- misdirection
- consequence callbacks
- alternate-reality transition

### The Wizard
- foreshadowing
- ordeal preparation
- hidden-system interpretation
- cosmic callback

### Bufo D' Clown
- performance events
- venue spectacle
- prop interactions
- comic/sincere tonal switch

### Handstand Dan
- physical minigames
- movement challenges
- inverted animation family
- repeat festival callback

### Sniffany
- social continuity
- quest-state callbacks
- camp → venue → night → 4:00 AM → ordeal continuity
- practical and emotional grounding

---

## 12. Raccoon encounter

The raccoon remains a creature encounter rather than a named-cast slot.

Required verbs:
- OFFER SNACK
- INTIMIDATE
- DISCUSS BOUNDARIES
- ACCEPT LOSS

Required presentation:
- map actor
- encounter close-up
- reaction frame
- persistent consequence
- later callback potential

---

## 13. Golden Scene implementation order

### C1 — Papa Wook
- restore visibility
- bind hero body
- four-direction identity

### C2 — Sniffany
- canonical native sprite
- actor
- portraits
- paginated dialogue
- quest-state hook

### C3 — Raccoon
- map actor
- encounter
- menu
- consequence

### C4 — Handstand Dan
- campground cameo
- signature inverted animation
- first physical side quest

### C5 — Train Station
- route guidance
- gate-transition setup

### C6 — Bufo D' Clown
- performance grammar seed

### C7 — Loki
- night-side-quest seed

### C8 — The Wizard
- foreshadowing seed

### C9 — visual QA
- native screenshot capture
- compare against Board A/B
- character score >= 9.0

The named cast enters through authored scene roles, not as a crowd dump.

---

## 14. Naming non-regression gate

Forward production fails if any deprecated placeholder identity appears in:
- active scene `.gbsres`
- active actor `.gbsres`
- native sprite symbols
- active dialogue
- quest IDs
- save-state keys
- current UI labels
- active production docs

Historical receipts, archived branches and migration notes are exempt only when clearly marked provenance.

---

## 15. Cartridge-class acceptance

Hero gate:

```text
SILHOUETTE_READABILITY=PASS
FOUR_DIRECTION_IDENTITY=PASS
WALK_CYCLE=PASS
IDLE_CYCLE=PASS
CONTEXT_POSES=PASS
PORTRAIT_FAMILY=PASS
DIALOGUE_BINDING=PASS
NATIVE_RESOURCE_BINDING=PASS
NATIVE_WEB_RENDER=PASS
ROM_BUILD=PASS
VISUAL_CONTRACT_SCORE>=9
```

Principal-NPC gate:

```text
DISTINCT_SILHOUETTE=PASS
SIGNATURE_ANIMATION=PASS
MAP_ACTOR=PASS
PORTRAIT_FAMILY=PASS
DIALOGUE_PRESENTATION=PASS
STATE_CALLBACK=PASS
NATIVE_RENDER=PASS
```

Level 10 means the player can identify who is on screen before reading the name.

---

## 16. Non-regression law

Frozen unless diagnostics prove failure:
- GB Studio 4.3.2 CLI
- Node / Ubuntu / GBDK
- native 4.x migration
- ROM build path
- GitHub publication
- GitHack publication

Character work begins at the existing native project and ends at screenshot proof.

---

## 17. Command-to-proof handoff

```text
CANONICAL CAST
        ↓
CHARACTER ASSET CONTRACT
        ↓
PAPA WOOK HERO FAMILY
        ↓
SNIFFANY GOLDEN SCENE
        ↓
RACCOON ENCOUNTER
        ↓
HANDSTAND DAN
        ↓
TRAIN STATION
        ↓
BUFO D' CLOWN
        ↓
LOKI
        ↓
THE WIZARD
        ↓
GB STUDIO RESOURCE BINDING
        ↓
MAKE:WEB + MAKE:ROM
        ↓
SCREENSHOT QA
        ↓
CARTRIDGE-CLASS CHARACTER RECEIPT
```

**Immediate executable target:** Papa Wook + Sniffany + raccoon in the already-proven Golden Campground, with deprecated placeholder identities removed from the active runtime graph.