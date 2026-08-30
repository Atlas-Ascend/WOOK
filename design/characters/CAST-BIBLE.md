# WOOK Canonical Cast Bible

**Status:** FROZEN ACTIVE CANON  
**Applies to:** WOOK V4 — Cartridge Class and all forward production branches

## Canon law

The active named cast is:

1. **Papa Wook**
2. **Train Station**
3. **Loki**
4. **The Wizard**
5. **Bufo D' Clown**
6. **Handstand Dan**
7. **Sniffany**

Additional named characters may be added intentionally later. Until that happens, supporting roles remain functional/unnamed rather than receiving disposable placeholder names.

### Deprecated placeholder names

The following names are removed from active canon and MUST NOT appear in new dialogue, quests, actor resources, UI, save-state keys, production filenames, or forward-facing documentation:

- Moonbeam Jessica
- Sage Trevor
- Trent
- Space Dave
- Solar Charger Guy
- DJ Maybe Greg
- Lost Kyle
- Vanessa Van Person

Historical commits and receipts may retain these strings strictly as provenance. They are not aliases and do not imply one-to-one continuity with the canonical cast.

---

# Papa Wook

**Tier:** A — Hero  
**Function:** player character, practical mystic, accidental responsible adult, comic center, eventual carrier of the elixir.

Papa Wook begins the weekend trying to locate his Crocs and ends it permanently altered by the journey.

Core visual anchors:
- broad hat mass
- rounded sunglasses
- full beard
- layered clothing
- small utility pack
- grounded silhouette

Arc:

```text
CHAOTIC SURVIVAL
      ↓
SOCIAL USEFULNESS
      ↓
RESPONSIBILITY
      ↓
ORDEAL
      ↓
MASTERY
      ↓
COSMIC RETURN
      ↓
OH.
```

---

# Train Station

**Tier:** B — Principal NPC  
**Archetype:** threshold guide / logistics oracle / movement-between-worlds character.

Train Station should feel like somebody whose name makes no sense until the player has known them for twenty minutes, after which no other name would be acceptable.

Narrative utility:
- early GA-camping orientation
- movement, timing, meetup and route knowledge
- venue-gate threshold scenes
- repeated appearances at improbable transit moments
- road-home resonance

Visual grammar:
- unmistakable travel/transit silhouette
- layered utility clothing
- one signature carried object or bag
- directional gesture animation
- portrait family emphasizing certainty, urgency and baffling calm

Train Station is not a replacement alias for any deprecated character.

---

# Loki

**Tier:** B — Principal NPC  
**Archetype:** trickster / chaos catalyst / alternate-reality hinge.

Loki is the character most capable of turning an ordinary side quest into a completely different branch of the night.

Narrative utility:
- misdirection without arbitrary cruelty
- optional quest chains
- social gambits
- night-camp escalation
- alternate-reality transition
- callbacks where a joke becomes mechanically important

Visual grammar:
- sharp silhouette
- asymmetry
- highly readable grin/eyes in portraits
- idle motion that suggests contained trouble
- one signature vanish/exit or misdirection animation

Loki should be funny, clever and consequential rather than a generic villain.

---

# The Wizard

**Tier:** B — Principal NPC  
**Archetype:** mentor / mystic technician / pattern recognizer.

The Wizard provides information that initially sounds ridiculous, later proves useful, and occasionally turns out to have been completely literal.

Narrative utility:
- foreshadowing
- ordeal preparation
- symbolic interpretation
- hidden-system explanations
- cosmic-journey continuity
- optional deep-lore conversations

Visual grammar:
- iconic headwear or hair silhouette
- long vertical shape contrasted against Papa Wook
- one unmistakable tool, staff, pouch, lantern or equivalent prop
- stillness as a signature motion cue
- portrait family capable of comedy and genuine gravity

The Wizard must never become an exposition vending machine. The player should still have to notice things.

---

# Bufo D' Clown

**Tier:** B — Principal NPC / Performance Character  
**Archetype:** clown prophet / festival performer / absurdity with precision timing.

Bufo D' Clown connects the social campground game to the performative scale of the venue.

Narrative utility:
- performance-side quests
- venue spectacle
- comic misdirection
- item/prop interactions
- surprising emotional sincerity
- possible threshold role during the strangest night sequence

Visual grammar:
- silhouette readable instantly even at Game Boy scale
- exaggerated but controlled shape language
- distinctive face paint translated into four-color readability
- prop-based gestures
- performance animation family
- high-expression portrait set

The clown presentation must be authored, not a generic carnival stereotype.

---

# Handstand Dan

**Tier:** B — Principal NPC / Skill Character  
**Archetype:** physical-comedy specialist / movement challenge / reliable chaos athlete.

Narrative utility:
- introduces physical minigame grammar
- optional skill challenges
- crowd/performance interactions
- late-night side quests
- visual comedy without requiring dialogue
- callbacks during the full festival weekend

Visual grammar:
- upright and inverted silhouette families
- handstand loop
- recovery/wobble loop
- celebratory pose
- expressive compact portrait set

Handstand Dan should be recognizable upside down before the player can read his name.

---

# Sniffany

**Tier:** B — Principal NPC  
**Archetype:** recurring social anchor / companion / sharp observer.

Sniffany is one of the key continuity characters linking camp, venue, night return, ordeal and later weekend states.

Narrative utility:
- early campground social grounding
- dialogue timing and comedy
- quest-state continuity
- relationship callbacks
- practical information
- emotional contrast during 4:00 AM and ordeal scenes

Visual grammar:
- immediately distinct hair/headwear silhouette
- one signature accessory
- expressive brows/eyes in portraits
- skeptical idle
- amused reaction
- serious/grounded portrait state

Sniffany is the first principal NPC to be implemented beside Papa Wook in the Golden Scene.

---

# Non-named recurring entities

These remain valid without becoming part of the named cast:

## Raccoon
Encounter creature and negotiating party. Never treated as a generic enemy. The raccoon may recur as motif, consequence, memory or cosmic callback.

## Festival staff / security / vendors / campers
Use functional role labels unless a character earns a deliberate canonical name.

## Crowd characters
May use visual archetype identifiers internally (`camper_01`, `vendor_03`, `security_02`) but not fake narrative names.

---

# Production rule

Every named-character resource must resolve to one of the canonical production identities:

```text
papa_wook
train_station
loki
the_wizard
bufo_d_clown
handstand_dan
sniffany
```

No deprecated placeholder identity may be introduced into a new native `.gbsres` resource.

**Canonical cast law:** if a character is important enough to have a name, the name is intentional.