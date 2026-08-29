# WOOK V4 — HUD, State, Runtime Architecture

**Purpose:** make every gameplay screen, quest, dungeon, social interaction, and chapter transition operate against a coherent state model rather than one-off scripts.

---

# 1. HUD doctrine

The HUD is contextual, sparse, and readable. It must never cover the world merely because data exists.

## Default exploration HUD

```text
┌────────────────────────────────────────┐
│ BAT 17%   VIBES 42   CROCS 0/2         │
│                                        │
│              WORLD                     │
│                                        │
│                               $ 14     │
└────────────────────────────────────────┘
```

Visible by default:
- Battery
- Vibes
- current critical quest counter when relevant
- Cash or Groundscore only when contextually relevant

Hidden behind menus:
- Responsibility
- Wook Karma
- full inventory
- affinity
- quest history
- schedule
- map

The system should communicate important state without turning WOOK into an accounting interface.

---

# 2. Core state domains

```text
GAME_STATE
├── player
├── inventory
├── economy
├── social
├── quests
├── world
├── time
├── venue
├── dungeon
├── narrative
├── accessibility
└── proof/debug
```

## Player

```text
player:
  battery
  vibes
  responsibility
  wook_karma
  facing
  movement_mode
  animation_state
  current_map
  spawn_id
```

## Inventory

```text
inventory:
  crocs_left
  crocs_right
  water
  lighter
  phone
  power_bank
  wristband
  camp_marker
  quest_items[]
  strange_items[]
```

Inventory items must carry stable logical IDs separate from display names.

## Economy

```text
economy:
  cash
  groundscore_points
  trade_flags
  vendor_reputation
```

## Social

```text
social:
  affinity[character_id]
  helped[character_id]
  promises[]
  owed_items[]
  active_companions[]
```

## Quest state

```text
quests:
  main[]
  camp[]
  people[]
  weird[]
  dungeon[]
  completed[]
  failed_optional[]
```

Main quests cannot fail permanently unless the narrative explicitly supports a recovery path.

## World

```text
world:
  camp_phase
  venue_phase
  crowd_state
  cleanup_state
  reality_stability
  weather_state
  map_mutations{}
```

## Time

WOOK uses authored chapter time, not a punishing real-time clock.

```text
time:
  festival_day
  daypart
  chapter_clock
  scheduled_events{}
```

The clock creates choice and atmosphere but does not create accidental hard-locks.

---

# 3. Stat definitions

## Battery
A practical resource and narrative pressure source.

Can affect:
- phone UI access,
- directions,
- messages,
- social coordination,
- camera/memory capture,
- Ordeal solution options.

Must always have non-phone fallback routes for critical-path objectives.

## Vibes
Represents current momentum / social-emotional ease, not mental health.

Can affect:
- flavor dialogue,
- animation expression,
- optional interaction outcomes,
- music stingers,
- minigame forgiveness.

Vibes must never become a morality score.

## Responsibility
The hidden hero stat.

Raised by:
- helping people,
- preparing camp,
- carrying water,
- following through,
- cleanup,
- remembering commitments.

It unlocks competence, not punishment.

## Wook Karma
Tracks reciprocal social goodwill and consequences.

Raised by fair trades, returned items, help, and community actions.

It should create callbacks rather than simplistic good/evil endings.

## Groundscore
A playful scavenging currency/state representing useful found objects.

Groundscore can resolve improvised solutions later if the player kept the right weird thing.

---

# 4. Full-screen systems

## START — Quest / Inventory hub

Tabs:
- QUESTS
- INVENTORY
- MAP
- PEOPLE
- WEEKEND

## Phone

Diegetic phone UI:
- battery
- messages
- map
- schedule
- notes
- camera/memories

Phone access may degrade with battery, but critical game information always exists elsewhere.

## Trader

Dedicated composition:
- seller portrait
- item list
- cash / trade value
- description
- consequence hint where appropriate

## Encounter

Dedicated composition for special encounters such as raccoon negotiations.

## Quest Complete

A brief high-energy ceremony with:
- quest name,
- item/state reward,
- stat delta when meaningful,
- audio sting.

---

# 5. HUD modes

```text
HUD_MODE=EXPLORATION
HUD_MODE=VENUE
HUD_MODE=DUNGEON
HUD_MODE=ENCOUNTER
HUD_MODE=MINIGAME
HUD_MODE=QUIET
HUD_MODE=CUTSCENE
HUD_MODE=COSMIC
```

### Exploration
Battery + contextual quest tracker.

### Venue
Battery + current schedule cue + friend/meeting marker when active.

### Dungeon
Dungeon key/state indicators; hide irrelevant festival stats.

### Encounter
Replace HUD with encounter UI.

### Minigame
Only metrics required by the minigame.

### Quiet
Minimal or no HUD for 4 AM, goodbye, and emotional beats.

### Cosmic
HUD elements may transform symbolically, but all underlying state remains deterministic.

---

# 6. State-transition law

Every state mutation must be attributable to an event.

```text
EVENT
  ↓
PRECONDITION CHECK
  ↓
STATE MUTATION
  ↓
VISUAL/AUDIO RESPONSE
  ↓
QUEST CONSEQUENCE
  ↓
SAVE DIRTY FLAG
  ↓
RECEIPT/DEBUG TRACE (dev builds)
```

No critical variable should be mutated implicitly by unrelated dialogue.

---

# 7. Save architecture

Checkpoint classes:
- map entry,
- dungeon entry,
- dungeon completion,
- major quest completion,
- day transition,
- 4 AM campfire,
- Ordeal start/end,
- final-day transition,
- road-home start.

Save contract:

```text
SAVE
→ RELOAD
→ SAME MAP
→ SAME PLAYER SPAWN FAMILY
→ SAME QUEST STATE
→ SAME INVENTORY
→ SAME SOCIAL FLAGS
→ SAME WORLD PHASE
```

If exact physical coordinates are unsafe after a map revision, load through a stable spawn ID rather than stale raw coordinates.

---

# 8. State versioning

```text
save_schema_version
content_version
map_revision
```

Future builds may migrate old saves. Never silently reinterpret an old flag for a different purpose.

---

# 9. Character state

Every principal character can own:

```text
character_state:
  met
  affinity
  chapter
  current_map
  quest_stage
  helped_by_player
  owes_player
  visible_variant
  dialogue_variant
```

This enables recurring-cast continuity across the weekend.

---

# 10. Failure-resilient quest design

Critical path dependencies must obey:

```text
NO_SINGLE_POINT_OF_FAILURE
```

Examples:
- dead phone cannot block venue navigation;
- missed side quest cannot block the Ordeal;
- lost optional item can have alternate solution;
- schedule choice can change content but not corrupt progression.

Each critical objective should have at least:
- primary route,
- recovery route,
- explicit validation test.

---

# 11. Dungeon state

Dungeon-specific state remains scoped:

```text
dungeon:
  id
  entered
  rooms_visited
  switches{}
  keys{}
  puzzle_flags{}
  reward_claimed
  exit_unlocked
```

On exit, only intentional persistent consequences are promoted to global state.

---

# 12. Telemetry for development builds

Development builds should be able to emit a compact state receipt:

```text
MAP=ga_after_dark
PLAYER_SPAWN=campfire_south
MAIN_QUEST=night_return_03
BATTERY=8
RESPONSIBILITY=31
WOOK_KARMA=14
DUNGEON_PORTA=complete
SOFTLOCK_CHECK=pass
```

This is diagnostic telemetry, not player analytics.

---

# 13. HUD acceptance

```text
HUD_READABLE_AT_NATIVE_RESOLUTION=PASS
NO_CRITICAL_TEXT_CLIPPING=PASS
CONTEXT_MODE_CORRECT=PASS
MENU_RETURN_STATE=PASS
PHONE_FALLBACK_PATHS=PASS
QUEST_COUNTER_ACCURATE=PASS
STAT_MUTATION_VISIBLE_WHEN_NEEDED=PASS
QUIET_SCENES_NOT_OVERHUDDED=PASS
SAVE_RELOAD_EQUIVALENCE=PASS
```
