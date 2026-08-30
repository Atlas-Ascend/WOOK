# WOOK V4 — SDLC Command-to-Proof

**Objective:** define a complete software-development lifecycle for every chapter, map, character, system, dungeon, and cartridge release.

This is an aerospace-style assurance discipline: requirements traceability, deterministic builds, verification gates, failure analysis, reproducible evidence, and explicit release criteria. It is not a claim of NASA certification.

---

# 1. Lifecycle overview

```text
MISSION / EXPERIENCE INTENT
        ↓
REQUIREMENTS
        ↓
SYSTEM ARCHITECTURE
        ↓
CONTENT / LEVEL DESIGN
        ↓
RESOURCE CONTRACTS
        ↓
IMPLEMENTATION
        ↓
STATIC VALIDATION
        ↓
NATIVE BUILD
        ↓
UNIT / RESOURCE TESTS
        ↓
MAP / SYSTEM INTEGRATION TESTS
        ↓
PLAYTHROUGH TESTS
        ↓
FAILURE-MODE TESTS
        ↓
VISUAL / AUDIO QA
        ↓
ROM / WEB ARTIFACT HASHING
        ↓
RELEASE CANDIDATE
        ↓
FULL CAMPAIGN REGRESSION
        ↓
PUBLICATION
        ↓
POST-RELEASE RECEIPT
```

No phase is considered complete merely because a document exists.

---

# 2. Requirement classes

Every work packet identifies requirements in these classes:

```text
FUN      gameplay / game feel
VIS      visual presentation
AUD      music / sound
NAR      narrative / dialogue
SYS      state / inventory / quest systems
MAP      level / collision / routing
CHR      character / animation / portrait
UI       HUD / menus / text
PERF     performance / ROM budgets
SAFE     softlock / corruption / recovery
BUILD    compiler / artifact production
PROOF    evidence / hashes / receipts
```

Example:

```text
MAP-GA-001  Player can traverse Papa's tent to GA Main Lane.
SAFE-GA-004 Dead phone cannot block the critical path.
CHR-PAPA-012 Papa Wook remains recognizable in all four directions.
UI-TEXT-003 Dialogue must not clip at native resolution.
```

---

# 3. Requirement traceability

Every implemented feature should trace:

```text
REQUIREMENT
   ↓
DESIGN ELEMENT
   ↓
RESOURCE / SCRIPT
   ↓
TEST
   ↓
EVIDENCE
   ↓
RELEASE RECEIPT
```

A requirement with no test is incomplete.
A test with no requirement is suspicious scope.
A PASS with no evidence is not proof.

---

# 4. Work packet model

Each production slice receives an immutable packet ID.

Examples:

```text
WOOK-MAP-GA-001
WOOK-CHAR-PAPA-002
WOOK-DUNGEON-PORTA-001
WOOK-HUD-001
WOOK-AUDIO-DAY1-001
WOOK-CHAPTER-ORDEAL-001
```

Each packet contains:
- mission,
- frozen inputs,
- requirements,
- files/resources touched,
- implementation plan,
- verification plan,
- rollback boundary,
- proof outputs,
- definition of done.

---

# 5. Level SDLC loop

Every map follows the same loop.

## L0 — Experience brief
Define:
- why the map exists,
- desired emotion,
- player objective,
- narrative state,
- mechanical novelty,
- exit condition.

## L1 — Map specification
Define:
- dimensions,
- landmarks,
- entrances/exits,
- actor budget,
- collision topology,
- trigger topology,
- audio zones,
- secrets,
- quest hooks.

## L2 — State contract
Define:
- allowed entry states,
- mutations,
- persistence,
- recovery states,
- impossible states.

## L3 — Art/resource contract
Define:
- background/tile resources,
- foregrounds,
- sprites,
- portraits,
- UI,
- palettes,
- animation frames.

## L4 — Implementation
Create or modify only the required native GB Studio resources and scripts.

## L5 — Static validation
Validate:
- JSON/resource syntax,
- IDs,
- references,
- duplicate symbols,
- missing assets,
- required actors,
- required triggers.

## L6 — Native compile
Use the frozen existing compiler factory.

```text
make:web
make:rom
```

## L7 — Integration tests
Validate:
- spawn,
- movement,
- collision,
- dialogue,
- quest events,
- exits,
- state mutation,
- save/reload.

## L8 — Failure-mode tests
Attempt:
- wrong route,
- dead battery,
- missing optional item,
- repeated interaction,
- save in transition,
- backtrack,
- revisit after state change,
- menu cancel,
- boundary collision.

## L9 — Presentation QA
Score:
- composition,
- sprite readability,
- animation,
- text layout,
- HUD,
- audio timing,
- scene rhythm.

## L10 — Proof
Hash artifacts, record commit, record tests, create receipt.

## L11 — Regression
Replay adjacent maps and all dependencies that share state/resources.

---

# 6. Character SDLC loop

```text
IDENTITY BRIEF
↓
SILHOUETTE
↓
MODEL SHEET
↓
OVERWORLD FAMILY
↓
ANIMATION FAMILY
↓
PORTRAIT FAMILY
↓
SIGNATURE INTERACTION
↓
GB STUDIO RESOURCE BINDING
↓
MAP INTEGRATION
↓
DIALOGUE / STATE TEST
↓
NATIVE BUILD
↓
SCREENSHOT QA
↓
CHARACTER RECEIPT
```

Principal-character acceptance requires personality to be visible before dialogue is read.

---

# 7. Dungeon SDLC loop

Each dungeon has:
- dungeon thesis,
- navigation grammar,
- puzzle grammar,
- state model,
- room graph,
- escalation curve,
- reward,
- exit transformation,
- failure recovery.

Verification includes room-by-room reachability and a complete state-space audit for required switches/keys.

---

# 8. HUD/UI SDLC loop

For every screen:

```text
INFORMATION NEED
↓
LAYOUT WIREFRAME
↓
NATIVE PIXEL COMPOSITION
↓
INPUT MODEL
↓
STATE BINDING
↓
CANCEL/BACK BEHAVIOR
↓
TEXT OVERFLOW TEST
↓
NATIVE RESOLUTION TEST
↓
MOBILE SHELL TEST
```

No menu ships without deterministic return behavior.

---

# 9. Audio SDLC loop

Each map has:
- base theme or ambience,
- transition cues,
- interaction SFX,
- success/failure stings,
- silence strategy.

Audio verification checks:
- no unintended restart loops,
- transition timing,
- cue duplication,
- dialogue audibility/legibility,
- ROM budget.

---

# 10. Failure Mode and Effects Analysis (FMEA)

Every critical system identifies likely failure modes.

Example:

| Failure | Effect | Severity | Detection | Mitigation |
|---|---|---:|---|---|
| Player hidden after title | game appears broken | high | spawn test | explicit sprite activation |
| Bad collision at exit | softlock | high | route traversal | safe exit tile + test |
| Dead phone blocks quest | hard progression stop | high | battery-zero scenario | analog fallback route |
| Dialogue clipping | unreadable story | medium | screenshot test | authored pagination |
| Duplicate resource ID | build/runtime ambiguity | high | static validator | deterministic IDs |
| Save loads into wall | softlock | high | save/reload test | stable spawn IDs |

High-severity failures cannot be waived without explicit design change.

---

# 11. Verification pyramid

```text
                FULL WEEKEND PLAYTHROUGH
              /                        \
         CHAPTER REGRESSION        FAILURE RUNS
        /             \
    MAP TESTS       SYSTEM TESTS
   /       \         /       \
RESOURCE  STATE   UI/HUD    QUEST
   \       |         |       /
       STATIC VALIDATION
              ↓
         NATIVE BUILD
```

The ROM itself is the integration artifact.

---

# 12. Build reproducibility

A release receipt records:

```text
repository
branch
commit
GB Studio version
build timestamp
ROM SHA256
web index SHA256
resource manifest hash
test matrix result
visual QA result
known limitations
```

A release is reproducible when the same commit and toolchain can create equivalent outputs.

---

# 13. Non-regression law

Already-proven infrastructure remains frozen unless a diagnostic proves it failed.

Do not respond to a character, map, or dialogue problem by reinstalling:
- Ubuntu,
- Node,
- GBDK,
- GB Studio,
- Git,
- hosting.

Operate at the first red gate only.

---

# 14. Performance and cartridge budgets

Every chapter tracks:
- ROM size,
- unique tiles,
- sprite tile demand,
- actor count,
- animation frames,
- music footprint,
- bank pressure,
- build time,
- native frame behavior.

Budgets are established empirically from compiler output and tightened when actual limits appear. Do not invent headroom.

---

# 15. Quality gates

## Gate A — Architecture
Requirements complete, state model defined, no unresolved critical ambiguity.

## Gate B — Resource
All native resource references valid.

## Gate C — Compile
Native web + ROM both build.

## Gate D — Functional
Critical path works from entry to exit.

## Gate E — Recovery
Failure/revisit/save paths do not softlock.

## Gate F — Presentation
Visual/audio/HUD scores meet chapter target.

## Gate G — Regression
Adjacent and shared systems remain green.

## Gate H — Release
Hashes, commit, receipt, publication proof complete.

---

# 16. Chapter release train

```text
C0 GOLDEN CAMPGROUND
↓
C1 GA + LONG WALK
↓
C2 GATES + FIRST REVEAL
↓
C3 DAY ONE VENUE
↓
C4 GA AFTER DARK
↓
C5 ALTERNATE REALITY + PORTA DUNGEON
↓
C6 4 AM
↓
C7 ORDEAL
↓
C8 DAY TWO + TOTEM DUNGEON
↓
C9 NIGHT TWO
↓
C10 FINAL DAY
↓
C11 LAST NIGHT
↓
C12 PACK DOWN
↓
C13 ROAD HOME
↓
C14 COSMIC JOURNEY
↓
C15 OH.
```

A later chapter never becomes an excuse to lower an earlier chapter's acceptance standard.

---

# 17. Definition of cartridge-class complete

WOOK is release-ready only when:

```text
ALL_CRITICAL_REQUIREMENTS=VERIFIED
ALL_CHAPTERS=FUNCTIONAL
ALL_DUNGEONS=REACHABLE_AND_EXITABLE
NO_KNOWN_CRITICAL_SOFTLOCKS
SAVE_RELOAD_MATRIX=PASS
HUD_STATE_MATRIX=PASS
CHARACTER_CANON=PASS
NATIVE_WEB=PASS
ROM=PASS
FULL_GAME_REGRESSION=PASS
VISUAL_STANDARD=PASS
AUDIO_STANDARD=PASS
PUBLICATION_PROOF=PASS
```

The final product should feel authored from first input to final `OH.` rather than assembled from isolated demos.
