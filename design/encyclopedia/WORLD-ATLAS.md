# WOOK — WORLD ATLAS

## Macro topology

```text
PAPA'S CAMP / QUESTIONABLE CAMPGROUND
        ↓
GA MAIN LANE
        ↓
THE LONG WALK
        ↓
VENUE SECURITY
        ↓
FIRST REVEAL OVERLOOK
        ↓
FESTIVAL CONCOURSE
   ┌────┼────────┬─────────┐
   ↓    ↓        ↓         ↓
MAIN   ART     SIDE      FOOD/
STAGE  GROVE   STAGE     WATER
   └────┴────────┴─────────┘
        ↓
VENUE EXODUS
        ↓
GA AFTER DARK
        ↓
LOOPING CAMP LANE
        ↓
PORTA-POTTY LABYRINTH
        ↓
IMPOSSIBLE SHORTCUT
        ↓
4 AM CAMP
        ↓
ORDEAL SEARCH GRID
        ↓
DAY TWO VENUE
        ↓
TOTEM FOREST
        ↓
NIGHT TWO / SECRET SET
        ↓
FINAL DAY / FINAL SET
        ↓
EMPTYING GA
        ↓
PARKING EXIT
        ↓
HIGHWAY
        ↓
ROADSIDE STOP
        ↓
ASTRAL HIGHWAY
        ↓
MEMORY CONSTELLATION
        ↓
THRESHOLD HOME
        ↓
HOME
```

## Persistent map families

### Questionable Campground
Phases:
- C00 morning/wake;
- C01 active daytime;
- C04 after-dark chaos;
- C05 reality-drift variant;
- C06 4 AM quiet;
- C08 morning-after mastery;
- C10 final morning;
- C12 pack-down.

Landmarks that must remain spatially legible across variants: Papa tent, communal campfire, van row, canopy cluster, cooler/water area, altar/weird-object table, GA lane exit, raccoon route.

### GA Main Lane
Phases:
- normal prep;
- night return;
- post-Ordeal competence;
- final morning/pack-down.

Functions: social hub, water, camp marker, neighbor quests, route orientation, trade, camp-state exposition through environment rather than text dump.

### The Long Walk
Phases:
- first approach;
- night return/exodus;
- Day Two efficient route;
- final-day route;
- pack-down exit.

Functions: anticipation, changing crowd density, distance-to-venue audio, hydration decision, route memory.

### Festival Concourse
Phases:
- Day One orientation;
- night exodus state;
- Day Two mastery;
- final-day closure.

Functions: main hub, schedule choice, vendor utility, meeting points, branch toward Main Stage, Side Stage, Art Grove, Food Row, Water, Merch, Lost & Found, Quiet Hill.

### Art Grove
Functions: Crystalpher/Amethyst/Moldavite Mike chains, inspection, trade, strange collectibles, environmental puzzles, quieter pacing, hidden route.

### Main Stage
Functions: spectacle, crowd position, friend-finding, totem occlusion, rhythm response, memory capture, final-set callback architecture.

## Dungeon geography

### Porta-Potty Labyrinth
The player enters from a geographically ordinary camp/utility edge and exits somewhere impossible. Room grammar should use repeating doors, subtle landmark differentiation, sound cues and stateful switches. A reset route must always exist.

### Totem Forest
A venue-space dungeon whose walls are not traditional walls. Giant totems, crowd masses and art structures create sightline occlusion. Navigation depends on landmark memory and audio.

### Memory Constellation
Not literal physical geography. It is a state-rendered challenge space assembled from remembered systems and symbols. Room order or behavior may vary by accumulated state while the set of critical completion routes remains verified.

## Ordeal Search Grid
The Ordeal uses several interconnected zones rather than one linear corridor. Search sectors must permit multiple route solutions, support different ally availability, and provide recovery when phone, supplies or relationships are weak.

## Road-home topology

Parking Exit is still festival logistics. Highway begins ordinary. Roadside Stop provides a believable transitional pause and impossible callback opportunity. Astral Highway evolves from the same road grammar rather than hard-cutting to a disconnected “space level.” Threshold Home gradually restores ordinary geometry.

## Map-state law

A recurring map variant may alter:
- actors;
- props;
- collision gates;
- interactables;
- palette/lighting;
- audio;
- quest hooks;
- dialogue;
- secrets;
- crowd density.

It must preserve enough canonical landmarks that the player's learned spatial model has value unless the specific design objective is to challenge that model (C05).

## Transition law

Every map transition defines:
- source map;
- source exit ID;
- destination map;
- stable destination spawn ID;
- preconditions;
- state mutations;
- fade/audio policy;
- recovery route;
- save policy.

No chapter boundary depends on an anonymous coordinate with no stable spawn identity.
