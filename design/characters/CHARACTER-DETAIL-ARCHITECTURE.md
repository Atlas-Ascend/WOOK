# WOOK V4 — Character Detail Architecture

**Campaign:** GA-WOOK-V4-CHARACTER-DETAIL-001  
**Baseline:** WOOK V4 native GB Studio 4.3.2 build is already proven.  
**Purpose:** Increase character fidelity without rebuilding the toolchain, replacing the native project, or regressing command-to-proof.

---

## 1. Architectural law

Character quality is not a single sprite problem. It is a layered presentation system:

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

No character is considered complete because one PNG exists.

A character is complete only when the required presentation layers are authored, bound into the GB Studio resource graph, exercised in a native scene, and visually verified against the canonical WOOK boards.

---

## 2. Character fidelity tiers

WOOK uses four production tiers. This prevents every background NPC from consuming protagonist-level memory while ensuring important characters are visibly richer.

### Tier A — Hero

Applies to:
- Papa Wook

Required:
- full four-direction locomotion
- four-direction idle
- turn frames
- contextual poses
- item-acquisition pose
- phone pose
- campfire sit
- confusion reaction
- dance loop
- encounter negotiation pose
- exhausted pose
- victory pose
- 8+ dialogue portraits
- special cutscene portraits
- late-game animation variation

### Tier B — Principal NPC

Applies to:
- Moonbeam Jessica
- Sage Trevor
- Trent
- Space Dave
- Solar Charger Guy

Required:
- four-direction idle
- four-direction walk where narratively needed
- 2–4 contextual poses
- 4+ portraits
- one signature animation
- scene-specific staging

### Tier C — Supporting NPC

Examples:
- DJ Maybe Greg
- Lost Kyle
- Vanessa Van Person
- festival staff
- camp neighbors

Required:
- one strong silhouette
- two-direction or four-direction idle as needed
- 1–2 walk loops
- 1 portrait or portraitless dialogue by design
- one readable prop/accessory marker

### Tier D — Encounter / Creature

Examples:
- raccoon
- environmental creatures

Required:
- encounter silhouette
- idle motion
- reaction motion
- dedicated encounter composition
- non-generic interaction verbs

---

## 3. Pixel density doctrine

The current weakness is not simply sprite size; it is insufficient authored information per frame.

### Overworld target

The overworld sprite must communicate, at a glance:
- hat shape
- hair / beard mass
- eyewear
- torso layering
- backpack / gear mass
- arm direction
- foot stance
- facing direction

A Papa Wook frame that reads only as `hat + square body` fails.

### Detail priority order

When pixel budget is constrained, preserve in this order:

1. silhouette
2. face framing
3. hat / hair / beard
4. primary clothing mass
5. backpack / prop
6. hands / gesture
7. secondary clothing texture
8. tiny ornamentation

Tiny details that destroy silhouette clarity are rejected.

---

## 4. Papa Wook master visual grammar

Papa Wook must be recognizable in black silhouette and in four-color Game Boy rendering.

### Mandatory identity anchors

- broad brim or bucket-style hat mass
- circular / rounded sunglasses
- large beard mass
- layered outerwear
- small utility pack / backpack
- slightly wide, grounded stance
- compact but expressive arm gestures

### Proportion contract

The design should avoid both extremes:
- **too chibi:** giant head, unreadable clothing
- **too realistic:** thin limb detail that collapses at Game Boy scale

Target: readable adventure-RPG proportions with a head large enough to carry the hat/beard identity and a torso large enough to show layered clothing.

### Motion personality

Early game:
- slightly loose timing
- modest secondary bob
- asymmetrical idle variation

Late game:
- more deliberate cadence
- cleaner stance
- same comic warmth

The arc should be visible in motion without turning him into a different person.

---

## 5. Overworld sprite architecture

### Required Papa Wook animation groups

```text
papa_wook/
├── idle/
│   ├── down
│   ├── up
│   ├── left
│   └── right
├── walk/
│   ├── down
│   ├── up
│   ├── left
│   └── right
├── reactions/
│   ├── confused
│   ├── delighted
│   ├── annoyed
│   └── exhausted
├── context/
│   ├── phone
│   ├── item_get
│   ├── campfire_sit
│   ├── dance
│   ├── negotiate
│   └── victory
└── cutscene/
    ├── look_up
    ├── look_down
    └── freeze_pose
```

### Recommended cadence

Locomotion should use compact loops with deliberate contact frames.

For a 4-frame walk:

```text
CONTACT → PASS → CONTACT → PASS
```

Do not use vertical bob as the only evidence of walking.

Arms, pack mass, and legs must visibly change.

---

## 6. Portrait architecture

Portraits are the primary place where personality detail becomes visible.

### Papa Wook required portrait set

1. neutral
2. confused
3. delighted
4. concerned
5. annoyed
6. enlightened / realization
7. phone-focused
8. victory
9. exhausted
10. deadpan
11. suspicious
12. unexpectedly responsible

### Moonbeam Jessica

1. neutral
2. skeptical
3. amused
4. serious
5. exasperated
6. impressed

### Sage Trevor

1. neutral mystic
2. grave wisdom
3. impossible confidence
4. porta-potty revelation
5. unexpectedly practical

### Portrait composition law

Every portrait must preserve:
- hair silhouette
- headwear
- face contour
- eye treatment
- mouth / beard geometry
- one dominant emotional cue

Portraits must not look like unrelated redraws of the same character.

---

## 7. Character detail layers

Every principal character is authored as layered design information even when the final output is flattened.

```text
BASE BODY
 + HEAD MASS
 + HAIR / BEARD
 + HEADWEAR
 + EYEWEAR
 + OUTERWEAR
 + PACK / PROP
 + HAND GESTURE
 + EXPRESSION
 + SHADOW / CONTACT
```

This architecture allows consistent regeneration and revision.

If one character needs a new pose, the artist should not redraw identity from memory; the pose is assembled against the same visual grammar.

---

## 8. NPC differentiation matrix

NPC detail must create immediate social readability.

| Character | Primary silhouette | Signature prop | Motion cue | Portrait cue |
|---|---|---|---|---|
| Papa Wook | hat + beard + pack | phone / Crocs | loose-to-grounded | sunglasses + beard |
| Jessica | hair/headband mass | cup / wristband | impatient lean | expressive brows |
| Trevor | hat + beard + long torso | staff / pouch | eerie stillness | intense eyes |
| Trent | practical cap / trader stance | ledger / cash | transactional hand | raised brow |
| Space Dave | lanky silhouette | mystery bag | drifting sway | distant grin |
| Solar Charger Guy | utility gear silhouette | panel / cable | cable fussing | sunburnt focus |
| Raccoon | compact masked body | snack target | alert tail | encounter close-up |

No two principal NPCs should share an unmodified silhouette family.

---

## 9. GB Studio implementation architecture

Character detail must enter the existing native resource graph rather than live as unbound repo art.

```text
art/source/characters/
        ↓
production export
        ↓
game/project/assets/sprites/
        ↓
*.png.gbsres
        ↓
GB Studio sprite resource IDs
        ↓
scene actors
        ↓
actor scripts / animation state
        ↓
native web + WOOK.gb
```

### Required resource bindings

For each native character:
- sprite PNG
- matching `.gbsres`
- stable resource ID
- stable symbol
- scene actor resource or player sprite binding
- animation-state assignment

### Naming law

Use stable production names:

```text
spr_papa_wook
spr_moonbeam_jessica
spr_sage_trevor
spr_trent
spr_space_dave
spr_solar_charger_guy
spr_raccoon
```

Resource names may evolve visually; IDs should not churn without migration reason.

---

## 10. Player architecture

Papa Wook is not a decorative NPC. The native player actor must use the authored hero sprite family.

### Scene-entry contract

Every playable scene must verify:
- player active
- player visible
- correct sprite resource assigned
- valid spawn location
- valid facing direction
- player not trapped in collision

The title scene may deactivate or hide the player, but every transition into gameplay must restore the player explicitly.

This prevents the current failure mode where title-scene state leaks into the campground and Papa Wook becomes invisible.

---

## 11. Dialogue / portrait integration

Character detail is only valuable if the dialogue presentation displays it.

### Principal dialogue pattern

```text
PORTRAIT
NAME
1–3 authored lines
advance marker
```

Long prose is paginated manually.

Do not send browser-length paragraphs into Game Boy dialogue boxes.

### Example

```text
MOONBEAM JESSICA

Oh my god.
You finally woke up.
```

Advance.

```text
PAPA WOOK

Define "finally."
```

This preserves timing, typography, comedy, and character identity.

---

## 12. Encounter presentation

The raccoon encounter is a dedicated composition, not a normal map sprite with generic combat verbs.

Required:
- larger raccoon encounter art
- readable mask/tail/body detail
- contextual menu
- reaction frame after choice
- consequence routed back to world state

Canonical verbs:
- OFFER SNACK
- INTIMIDATE
- DISCUSS BOUNDARIES
- ACCEPT LOSS

The interaction grammar itself is part of character architecture.

---

## 13. Character-state model

Characters require visual state, not just narrative state.

Example Papa Wook state:

```text
visual_state:
  locomotion: idle|walk
  facing: up|down|left|right
  pose: default|phone|item_get|sit|dance|negotiate|victory|exhausted
  expression: neutral|confused|delighted|concerned|annoyed|enlightened
  arc_phase: early|mid|late
```

The game does not need to expose this exact schema at runtime, but production files and scripts should map cleanly to these concepts.

---

## 14. Production source architecture

```text
art/source/characters/
├── papa-wook/
│   ├── model-sheet/
│   ├── silhouette/
│   ├── overworld/
│   ├── portraits/
│   ├── context-poses/
│   └── exports/
├── moonbeam-jessica/
├── sage-trevor/
├── trent/
├── space-dave/
├── solar-charger-guy/
└── raccoon/
```

Final native-ready assets live in:

```text
game/project/assets/sprites/
game/project/assets/avatars/
```

Source art and compiled game assets are intentionally separate.

---

## 15. Golden Scene implementation order

Do not attempt all seven acts before character fidelity is proven.

### Phase C1 — Papa Wook visibility
- bind hero sprite
- restore player after title
- verify four directions

### Phase C2 — Papa Wook locomotion fidelity
- replace generic actor sheet
- walk cycles
- idle cycles

### Phase C3 — Jessica
- sprite
- actor
- portrait
- dialogue

### Phase C4 — Raccoon
- map actor
- encounter art
- encounter menu
- consequence

### Phase C5 — Trevor cameo
- sprite
- portrait
- signature dialogue

### Phase C6 — contextual hero poses
- phone
- item get
- victory
- sit

### Phase C7 — visual QA
- capture native screenshots
- compare against Board A and Board B
- score silhouette / portrait / density / composition

Only after C7 passes does the character language propagate across Acts II–VII.

---

## 16. Acceptance gates

A hero character passes only if all are true:

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

A principal NPC passes only if:

```text
DISTINCT_SILHOUETTE=PASS
MAP_ACTOR=PASS
SIGNATURE_POSE=PASS
PORTRAIT_FAMILY=PASS
DIALOGUE_PRESENTATION=PASS
NATIVE_RENDER=PASS
```

---

## 17. Non-regression law

Character-detail work must not reopen proven infrastructure.

Frozen unless a test proves otherwise:
- GB Studio 4.3.2 CLI
- Node / Ubuntu / GBDK toolchain
- native resource project migration
- ROM production path
- GitHub publication path
- GitHack publication path

Character work begins at the existing GB Studio project and ends at native proof.

---

## 18. Definition of Level 10

Level 10 does **not** mean maximum pixel count.

It means:
- immediately recognizable silhouettes
- expressive faces
- coherent animation
- strong visual differentiation
- authored staging
- no placeholder actors
- no generic default GB Studio sprite visible in a final scene
- personality visible before dialogue is read
- visual continuity between overworld, portrait, encounter, and cutscene art

The target is the feeling that a specialized 1992 cartridge art team repeatedly refined every important character until no frame looked provisional.

---

## 19. Command-to-proof handoff

```text
CHARACTER ARCHITECTURE
        ↓
ASSET CONTRACT
        ↓
PAPA WOOK HERO FAMILY
        ↓
PRINCIPAL NPC FAMILIES
        ↓
GB STUDIO RESOURCE BINDING
        ↓
GOLDEN SCENE
        ↓
MAKE:WEB + MAKE:ROM
        ↓
SCREENSHOT QA
        ↓
VISUAL CONTRACT RECEIPT
```

**Next executable build target:** Papa Wook hero binding + Jessica + raccoon inside the already-proven native Act I scene.
