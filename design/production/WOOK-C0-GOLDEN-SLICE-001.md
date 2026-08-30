# WOOK-C0-GOLDEN-SLICE-001

## Mission

Turn `The Questionable Campground` from a compiled native scene into the first cartridge-class gameplay slice of WOOK.

This packet begins above the already-proven GB Studio factory. It must not reinstall Node, Ubuntu, GBDK, rebuild the GB Studio CLI, or redo the 4.x migration unless a diagnostic proves one of those layers has failed.

## Frozen inputs

- proven GB Studio 4.3.2 toolchain
- proven native web build
- proven native `.gb` ROM build
- current 4.x resource graph
- Cartridge-Class canon and state architecture
- canonical core cast
- chapter SDLC controller

## Critical path

```text
TITLE
  ↓
QUESTIONABLE CAMPGROUND
  ↓
PAPA WOOK CONTROL
  ↓
SNIFFANY
  ↓
CROCS QUEST
  ↓
CROC #1
  ↓
RACCOON ENCOUNTER
  ↓
CROC #2
  ↓
QUEST COMPLETE
  ↓
HANDSTAND DAN / OPTIONAL CAMP CONTENT
  ↓
GA EXIT
```

## Required gameplay systems

### Player
- Papa Wook visible on gameplay entry
- stable player sprite binding
- four-direction identity
- deterministic collision
- valid spawn
- no title-scene hidden-state leak

### Characters
- Sniffany as stateful principal NPC
- Handstand Dan as optional challenge NPC
- raccoon as encounter actor

### Quest
- stable quest ID for `Where Are My Shoes?`
- Crocs state: `0/2 -> 1/2 -> 2/2`
- no duplicate Croc rewards
- quest completion ceremony
- completion persists through save/reload

### HUD
- Battery
- Vibes
- contextual `CROCS x/2`
- sparse exploration mode
- no text clipping

### Menus
- Inventory
- Quest Log
- Phone
- deterministic return to gameplay

### State
- Battery
- Vibes
- Responsibility
- Wook Karma
- Groundscore
- Sniffany met/helped state
- raccoon resolution state
- Handstand Dan challenge state
- secret state

### World
- real collision topology
- Papa tent
- campfire
- van row
- cooler zone
- altar / strange-object zone
- raccoon route
- GA exit

### Side content
- at least one side quest
- at least one secret
- at least two optional interactions

### Save / reload
- stable spawn family
- quest state preserved
- inventory preserved
- actors do not duplicate or ghost
- completion rewards do not repeat

## First-red-gate order

1. `PAPA_WOOK_CONTROLLER`
2. `SNIFFANY`
3. `HANDSTAND_DAN`
4. `RACCOON_ENCOUNTER`
5. `CROCS_0_TO_2`
6. `COLLISION_TOPOLOGY`
7. `HUD`
8. `PHONE`
9. `INVENTORY`
10. `QUEST_LOG`
11. `GROUNDSCORE`
12. `RESPONSIBILITY`
13. `WOOK_KARMA`
14. `SIDE_QUEST`
15. `SECRET`
16. `SAVE_RELOAD`
17. `GA_EXIT`
18. `NATIVE_WEB`
19. `ROM`
20. `VISUAL_QA`
21. `REGRESSION`
22. `RECEIPT`

The build controller must stop at the first unresolved gate rather than pretending later gates are complete.

## Acceptance

C0 is not qualified until all are true:

```text
ENTRY_STATE_VALID=PASS
PAPA_WOOK_CONTROLLER=PASS
SNIFFANY=PASS
HANDSTAND_DAN=PASS
RACCOON_ENCOUNTER=PASS
CROCS_0_TO_2=PASS
COLLISION_TOPOLOGY=PASS
HUD=PASS
PHONE=PASS
INVENTORY=PASS
QUEST_LOG=PASS
GROUNDSCORE=PASS
RESPONSIBILITY=PASS
WOOK_KARMA=PASS
SIDE_QUEST=PASS
SECRET=PASS
SAVE_RELOAD=PASS
GA_EXIT=PASS
NATIVE_WEB=PASS
ROM=PASS
VISUAL_QA=PASS
REGRESSION=PASS
RECEIPT=PASS
```

Only then may the chapter controller emit:

`C0_WHERE_ARE_MY_SHOES=QUALIFIED`
