# GB Studio Character Integration Architecture

**Scope:** Character fidelity only.  
**Do not rebuild:** Node, Ubuntu, GBDK, GB Studio CLI, project migration, Git history, hosting pipeline.

---

## 1. Current proven body

The WOOK V4 native body already exists and compiles.

```text
WOOK V4 native project
  game/project/WOOK.gbsproj
  game/project/assets/**
  game/project/project/**
        ↓
GB Studio 4.3.2 CLI
        ↓
make:web + make:rom
        ↓
site/gbstudio + releases/native/rom/WOOK.gb
```

Character work patches the project resource graph in place.

---

## 2. Required native resource family

For every production character, the repository must contain:

```text
PNG export
  +
PNG.gbsres metadata
  +
stable resource ID
  +
stable symbol
  +
scene/player binding
```

A pretty sprite in `art/source` is not a game feature until this chain exists.

---

## 3. Papa Wook native binding

### Goal

Replace any generic/default player appearance with the authored Papa Wook hero family.

### Native responsibilities

1. import the hero sprite sheet into `game/project/assets/sprites/`
2. create/maintain its `.gbsres`
3. assign the sprite resource as the playable player sprite
4. ensure title-screen hiding does not leak into gameplay
5. explicitly restore/activate player on campground entry
6. verify spawn, direction, collision safety
7. verify four-direction identity in the native web build

### State transition law

```text
TITLE
  player hidden/deactivated
        ↓ scene switch
CAMPGROUND ENTRY
  player activated
  hero sprite assigned
  position validated
  facing assigned
        ↓
PLAYABLE PAPA WOOK
```

The current invisible-player failure mode is therefore treated as a scene-state bug, not an art bug.

---

## 4. Actor architecture

Principal NPC actors should use stable IDs and explicit semantic symbols.

Suggested actor symbols:

```text
act_jessica_campground
act_raccoon_campground
act_trevor_campground
act_solar_charger_guy
```

Actor scripts should be small and event-oriented:

```text
ON_INTERACT
  ↓
state guard
  ↓
portrait dialogue
  ↓
state mutation
  ↓
optional item / stat change
  ↓
visual reaction
```

Avoid one giant scene script controlling every character interaction.

---

## 5. Portrait binding

Portraits belong to dialogue presentation, not the map sprite.

Recommended flow:

```text
actor interaction
   ↓
select portrait resource
   ↓
show authored dialogue page
   ↓
advance
   ↓
optional expression change
   ↓
continue / branch
```

Principal dialogue should deliberately choose expressions rather than always using one default portrait.

---

## 6. Animation resource strategy

GB Studio resource limits are treated as a production constraint, not a reason for generic characters.

### Hero

Use multiple sprite states/resources if necessary rather than forcing every contextual pose into one unwieldy sheet.

Logical grouping:

```text
spr_papa_wook_locomotion
spr_papa_wook_phone
spr_papa_wook_item_get
spr_papa_wook_campfire
spr_papa_wook_dance
spr_papa_wook_victory
```

Runtime scripts may swap sprite state/resources during special sequences and restore locomotion afterward.

### Principal NPCs

Prefer compact per-character sheets with one signature special-state resource where needed.

---

## 7. Golden Scene scene graph

The native Act I scene should evolve toward:

```text
scene_questionable_campground
├── player: Papa Wook
├── actor: Moonbeam Jessica
├── actor: Raccoon
├── actor: Solar Charger Guy
├── optional actor: Sage Trevor
├── trigger: Croc Left
├── trigger: Croc Right
├── trigger: tent interaction
├── trigger: van interaction
├── trigger: altar interaction
├── trigger: campfire interaction
├── collision map
└── scene entry
    ├── player activate
    ├── player sprite bind
    ├── intro state guard
    └── intro dialogue if first visit
```

This is the minimum scene graph required before the campground can resemble the canonical WOOK boards as a game rather than a static illustration.

---

## 8. Dialogue architecture

Dialogue is authored as cartridge pages.

Bad:

```text
You wake up. Your Crocs are gone. Your phone is at 17%. Somehow this is everyone else's fault...
```

Good:

```text
PAGE 1
SYSTEM
You wake up.
Your Crocs are gone.

PAGE 2
SYSTEM
Your phone:
17%.
Fantastic.

PAGE 3
PAPA WOOK
Somehow,
this is everyone
else's fault.
```

The architecture treats pagination as a production artifact because typography, timing, and comedy depend on it.

---

## 9. Quest/state binding

Character interactions should mutate explicit game state.

Suggested Golden Scene state model:

```text
intro_seen
jessica_spoken
raccoon_resolved
croc_left_found
croc_right_found
quest_shoes_complete
battery
vibes
responsibility
groundscore
wook_karma
cash
```

Visual states derive from game state where appropriate:
- found Croc disappears from world
- Jessica dialogue changes after first conversation
- raccoon reaction persists
- quest completion fires once

---

## 10. Encounter architecture

The raccoon encounter should be implemented as a dedicated scene or controlled presentation state.

```text
world actor interaction
       ↓
encounter presentation
       ↓
OFFER SNACK
INTIMIDATE
DISCUSS BOUNDARIES
ACCEPT LOSS
       ↓
branch consequence
       ↓
return to campground
       ↓
persist result
```

Encounter character art should be larger and more detailed than the map actor.

---

## 11. Build loop

Character implementation uses the already-proven native loop:

```text
PATCH RESOURCE GRAPH
       ↓
STATIC RESOURCE QA
       ↓
gb-studio-cli make:web
       ↓
gb-studio-cli make:rom
       ↓
local artifact hashes
       ↓
Git commit
       ↓
GitHub push
       ↓
GitHack native proof
       ↓
screenshot review
```

No install/bootstrap stage belongs in this loop.

---

## 12. First implementation packet

**Packet:** WOOK-CHAR-GOLDEN-001

### Changes

1. Papa Wook player resource
2. player activation on campground entry
3. four-direction Papa locomotion
4. Jessica native actor
5. Jessica portrait dialogue
6. raccoon native actor
7. raccoon encounter presentation
8. intro dialogue pagination

### Proof

```text
PLAYER_VISIBLE=PASS
PAPA_WOOK_IDENTITY=PASS
JESSICA_ACTOR=PASS
JESSICA_PORTRAIT=PASS
RACCOON_ACTOR=PASS
RACCOON_ENCOUNTER=PASS
DIALOGUE_LAYOUT=PASS
GB_STUDIO_NATIVE_WEB=PASS
GB_STUDIO_ROM=PASS
```

Only after this packet is visually approved should Trevor, Trent, Space Dave, and the rest of the cast inherit the production language.
