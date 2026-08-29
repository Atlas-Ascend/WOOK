# WOOK V4 — Cartridge Class
# Full Gameplay Map-by-Map Architecture

**Mission:** define the complete playable journey from the first frame in GA camping to the final cosmic return.  
**Design target:** commercial cartridge discipline comparable in intentionality to top-tier Nintendo-era adventure games, while remaining original WOOK fiction.  
**Engine baseline:** existing native GB Studio 4.3.2 pipeline.  

---

# Global gameplay loop

```text
ARRIVE IN MAP
   ↓
READ WORLD STATE
   ↓
ORIENT / EXPLORE
   ↓
MEET CHARACTER OR DISCOVER PROBLEM
   ↓
QUEST / PUZZLE / SOCIAL CHOICE / MINIGAME
   ↓
STATE MUTATION
   ↓
REWARD / CONSEQUENCE / CALLBACK FLAG
   ↓
OPTIONAL SECRET / SIDE QUEST
   ↓
EXIT GATE
   ↓
NEXT MAP
```

Every map must contain:
- a clear arrival beat,
- one primary objective,
- at least two optional interactions,
- at least one state-dependent variation,
- at least one visual landmark,
- at least one audio identity,
- a clean exit gate,
- and a proofable completion condition.

---

# CHAPTER 0 — WHERE ARE MY SHOES?

## Map 0A — The Questionable Campground

### Entry state

```text
TIME=late_morning
PHONE_BATTERY=17
CROCS=0/2
VIBES=42
RESPONSIBILITY=4
WOOK_KARMA=0
CASH=low
GROUND_SCORE=0
```

### Visible landmarks
- Papa Wook's tent
- communal fire ring
- van row
- canopy cluster
- altar / weird-object table
- cooler zone
- path toward GA hub
- raccoon route

### Critical path
1. Player regains control after authored intro pages.
2. Papa Wook becomes visible and controllable.
3. Sniffany establishes the initial quest: locate both Crocs and get ready to move.
4. Player searches tent/cooler/campfire zones.
5. First Croc is acquired through normal exploration.
6. Raccoon blocks or possesses access to second Croc.
7. Raccoon encounter introduces noncombat choice grammar.
8. Second Croc acquired.
9. Quest-complete ceremony fires.
10. Train Station or Sniffany announces venue gates are opening.

### Side quests
- Find a lighter that is never actually consumed by the main quest.
- Return somebody's cup.
- Help Hydration Hank refill water.
- Inspect suspicious altar items.
- Learn Handstand Dan's first balance challenge.

### Secret
A hidden interaction behind the van grants an item that appears useless until the Ordeal.

### Exit gate
`CROCS == 2` and `VENUE_READY == true`.

---

# CHAPTER 1 — GENERAL ADMISSION

## Map 1A — GA Main Lane

A wider social hub that teaches the player that the campground is a persistent home base, not a disposable tutorial.

### Critical path
- locate water station,
- secure wristband,
- charge phone or choose not to,
- check camp marker,
- meet Train Station,
- learn route to venue gates.

### Core cast
- Papa Wook
- Sniffany
- Handstand Dan
- Train Station
- Moonbeam
- Dr. Bronner

### Systems introduced
- persistent camp map
- NPC affinity/state
- optional responsibility tasks
- battery choices
- Groundscore economy
- quest log categories: MAIN / CAMP / WEIRD / PEOPLE

## Map 1B — The Long Walk

Transition trail from GA to venue perimeter.

### Gameplay
- moving crowds,
- route forks,
- environmental signs,
- first stamina-style pacing joke without becoming a survival sim,
- water decision,
- social interruption side quests,
- music heard faintly in distance and grows by screen.

### Exit gate
Reach venue security with valid wristband state.

---

# CHAPTER 2 — THROUGH THE GATES

## Map 2A — Venue Security

### Gameplay grammar
This is a social/puzzle gate, not combat.

Player must resolve:
- wristband check,
- bag state,
- water-bottle rule,
- missing friend ping,
- line selection.

Train Station functions as threshold guide.

### Branches
High Responsibility or prior helpfulness can open faster routes. Low preparation creates funny detours, not hard failure.

## Map 2B — First Reveal Overlook

A mostly authored visual sequence.

### Goal
Deliver the first major spectacle beat.

### Sequence
```text
walk corridor
↓
low-volume bass
↓
rumble / screen shake
↓
open overlook
↓
venue panorama
↓
full musical layer enters
↓
player control returns
```

No exposition dump. The environment communicates scale.

---

# CHAPTER 3 — LIT FAMILY REUNION: DAY ONE

## Map 3A — Festival Concourse

The central venue hub.

### Destinations
- Main Stage
- Side Stage
- Art Grove
- Food Row
- Water / Utility
- Merch
- Lost & Found
- Quiet Hill
- Secret Route

### Systems introduced
- festival clock
- scheduled events
- mutually exclusive choices
- crowd density states
- vendor economy
- performance quests

## Map 3B — Main Stage Day

### Gameplay
The show is interactive rather than a passive cutscene.

- choose crowd position,
- find friends,
- navigate totems,
- rhythm-response moments,
- collect visual/audio memories,
- handle mini social requests while music continues.

### Bufo D' Clown
Introduced here or at Art Grove. He is a chaos catalyst and optional-performance quest giver.

## Map 3C — Art Grove

### Purpose
A slower discovery space with visual secrets.

Characters:
- Crystalpher
- Amethyst
- Moldavite Mike
- rotating reserve cast

### Mechanics
- inspect art,
- trade strange collectibles,
- trigger environmental micro-puzzles,
- find alternate path back to concourse.

## Map 3D — Side Stage / Secret Set Route

A timed optional objective. Missing it does not fail the game; it changes later dialogue and memory flags.

---

# CHAPTER 4 — AFTER THE SHOW

## Map 4A — Venue Exodus

Crowds move back toward GA.

### Design goal
Make familiar geography feel transformed by time and population flow.

### Mechanics
- reverse navigation under crowd pressure,
- friend-finding,
- route choice,
- battery loss,
- new night-only dialogue.

## Map 4B — GA After Dark

The first large side-quest explosion.

### World state
```text
TIME=00:30→03:30
CAMP_LIGHTING=night
NPC_SET=night_roster
MUSIC=multiple_sources
QUEST_DENSITY=high
REALITY_STABILITY=declining
```

### Side quests
- The Speaker of Destiny
- The Missing Pashmina
- The Van That Isn't Our Van
- The Sacred Cooler
- Who Has My Phone?
- Drum Circle
- Tent Rescue
- Find the Camp Flag
- Groundscore chain quest
- Handstand Dan's impossible challenge

### Loki
Introduced during a route that appears normal at first.

---

# CHAPTER 5 — ALTERNATE REALITY

## Map 5A — The Looping Camp Lane

The same camp lane begins violating expectations.

### Mechanics
- repeated screen with changed objects,
- dialogue mutations,
- impossible NPC positions,
- route memory puzzle,
- sound motif reversal.

### Reality Stability system
A hidden state drives subtle differences. It is never presented as a sanity meter.

## Dungeon 5B — Porta-Potty Labyrinth

A real dungeon built from a ridiculous premise.

### Dungeon pillars
- orientation puzzle,
- switch / door logic,
- scent-arrow visual jokes without gross-out excess,
- item-state puzzle,
- looping corridors,
- The Wizard as intermittent guide,
- Loki as misdirection layer.

### Dungeon reward
Not a sword. A practical item, knowledge, or route key that later matters.

### Boss equivalent
A multi-stage navigation/social logic encounter rather than violence.

## Map 5C — The Impossible Shortcut

Completing the dungeon exits somewhere that should not spatially connect to it.

This establishes the game's cosmic grammar without explaining it.

---

# CHAPTER 6 — 4:00 AM

## Map 6A — Silent Camp Return

### Mood
The density drops dramatically.

- distant bass,
- sleeping tents,
- dying campfire,
- sparse NPCs,
- phone nearly dead,
- low UI motion.

### Gameplay
Mostly walking, inspecting, and choosing who to sit with.

### Campfire conversation
Sniffany, Moonbeam, The Wizard, or nobody may be present depending on state.

### Save state
This is a major checkpoint and narrative breath.

---

# CHAPTER 7 — THE ORDEAL

## Map 7A — Dawn Disruption

Something consequential goes wrong. The exact fiction can evolve, but the architecture is fixed:

- a friend needs help,
- resources are limited,
- phone access is degraded,
- route knowledge matters,
- prior social choices matter,
- the player must coordinate rather than merely fetch.

### Systems callback
Every major system from the opening chapters must become useful:

```text
WATER → practical consequence
BATTERY → communication consequence
MAP KNOWLEDGE → routing consequence
NPC AFFINITY → support availability
WOOK KARMA → willingness of others to help
RESPONSIBILITY → dialogue and options
GROUND SCORE → improvised solution potential
QUEST HISTORY → who trusts Papa Wook
```

## Map 7B — Search Grid

A multi-zone coordinated search / logistics sequence.

### Possible zones
- GA camp
- venue perimeter
- water station
- parking edge
- medical/support tent exterior
- wooded path

### No softlocks
Every required dependency has at least two resolution routes.

## Map 7C — Resolution

The ordeal resolves through accumulated competence and relationships.

Papa Wook is visibly changed in animation cadence and dialogue tone, but remains funny.

---

# CHAPTER 8 — DAY TWO: MASTERY

## Map 8A — Morning Reset

Same GA geography, new state.

### Changes
- tents shifted,
- new debris / cleanup,
- new NPCs,
- callbacks to Night One,
- some side quests auto-resolved or evolved.

### Papa Wook
The player now understands the systems, so the game stops tutorializing them.

## Map 8B — Venue Day Two

### New mechanics
- deeper schedule choices,
- relationship-specific routes,
- optional character chains,
- harder environmental puzzles,
- secret-stage access.

## Dungeon 8C — The Totem Forest

A venue-side maze/dungeon where tall totems obscure navigation.

### Mechanics
- landmark memory,
- audio localization,
- route triangulation,
- friend beacon state,
- hidden art path.

---

# CHAPTER 9 — NIGHT TWO

## Map 9A — Secret Set

A reward for exploration, social ties, or schedule knowledge.

### Gameplay
High-energy rhythm / crowd-navigation sequence with optional performance score.

## Map 9B — Campfire Constellation

Different camps become linked by social quests. The player can move between micro-hubs and resolve multi-character chains.

Loki, Bufo D' Clown, Handstand Dan, Moonbeam, and Moldavite Mike can all create intersecting outcomes.

---

# CHAPTER 10 — FINAL FESTIVAL DAY

## Map 10A — Last Morning

The world begins signaling impermanence.

### Gameplay
- packing decisions,
- final trades,
- unfinished quest warnings presented diegetically,
- goodbye conversations,
- optional photo/memory captures.

## Map 10B — Final Day Venue

All major recurring characters can appear based on their state.

### Player agency
Choose which unresolved relationships/quests to close before the final set.

---

# CHAPTER 11 — THE LAST NIGHT

## Map 11A — Final Main-Stage Approach

A procession through callbacks from the entire weekend.

### Requirements
- dynamic NPC presence from completed quest chains,
- musical motif convergence,
- visual callbacks,
- minimal HUD during emotional beats.

## Map 11B — Final Set

The spectacle peak.

### Game feel
The player remains interactive but is not burdened by busywork.

- movement,
- friend positioning,
- rhythm gestures,
- visual event triggers,
- crowd-response states.

### Resurrection beat
Papa Wook is not defeating a villain. The climax proves the internal transformation through how he moves, chooses, and shows up for others.

---

# CHAPTER 12 — PACK DOWN / GOODBYES

## Map 12A — Emptying GA

The same campground map is progressively stripped.

### State transitions
```text
FULL CAMP
↓
HALF PACKED
↓
VEHICLES LEAVING
↓
EMPTY PATCHES
↓
QUIET FIELD
```

### Gameplay
- return borrowed items,
- final Groundscore decisions,
- cleanup,
- goodbye dialogue,
- resolve remaining camp flags.

### Emotional function
Temporary city → empty field.

---

# CHAPTER 13 — THE ROAD HOME

## Map 13A — Parking Exit

A navigation/comedy puzzle about finding the correct vehicle and leaving a gigantic improvised city.

## Map 13B — Highway

### Mechanics
- route choices,
- roadside stops,
- memory-dialogue callbacks,
- weather/time shifts,
- sleep/rest decisions represented safely and non-simulative.

## Map 13C — Roadside Stop

Train Station may appear impossibly or be referenced. Reality begins to bend again.

### Reserve cast
Road-home roster enters here.

---

# CHAPTER 14 — COSMIC JOURNEY

## Map 14A — Astral Highway

The road gradually transforms into symbolic space.

### Visual grammar
- highway lines become stars,
- signs become quest memories,
- old locations reappear as impossible roadside fragments,
- music reuses themes in transformed form.

## Dungeon 14B — The Memory Constellation

A final noncombat dungeon built from state callbacks.

### Rooms
Each room represents a major weekend system:
- Water
- Battery
- Crocs
- Friendship
- Responsibility
- Groundscore
- Wook Karma
- The Ordeal

The solution is not a trivia quiz. Prior game state changes room behavior.

## Map 14C — The Threshold Home

The cosmic visuals collapse gently back into ordinary geography.

---

# CHAPTER 15 — OH.

## Map 15A — Home

Same-scale world. No giant final speech.

### Final interaction
Someone asks a simple question such as:

`How was the festival?`

Papa Wook pauses.

Final authored response:

`OH.`

Fade.

---

# Persistent map-state matrix

Every recurring map has time/state variants.

| Map | Day | Night | Post-Ordeal | Final Morning |
|---|---:|---:|---:|---:|
| Questionable Campground | yes | yes | yes | yes |
| GA Main Lane | yes | yes | yes | yes |
| Venue Concourse | yes | yes | yes | yes |
| Art Grove | yes | yes | optional | yes |
| Parking Edge | limited | yes | yes | yes |
| Long Walk | yes | yes | yes | yes |

The same geography is reused intentionally, but actors, props, audio, collision gates, lighting/palette, and quest affordances change by world state.

---

# Map acceptance contract

Every map must pass:

```text
ENTRY_STATE_VALID=PASS
PLAYER_SPAWN_VALID=PASS
PLAYER_VISIBLE=PASS
COLLISION_CLOSED=PASS
CRITICAL_PATH_COMPLETABLE=PASS
NO_SOFTLOCK=PASS
OPTIONAL_CONTENT_NONBLOCKING=PASS
EXIT_GATE_VALID=PASS
STATE_MUTATION_RECORDED=PASS
SAVE_RELOAD_EQUIVALENCE=PASS
AUDIO_CUE_VALID=PASS
HUD_STATE_VALID=PASS
NATIVE_WEB=PASS
ROM=PASS
```

A map that merely renders is not complete.
