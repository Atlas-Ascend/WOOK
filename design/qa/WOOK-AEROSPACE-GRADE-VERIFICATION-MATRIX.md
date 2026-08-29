# WOOK V4 — Aerospace-Style Verification Matrix

**Purpose:** apply mission-assurance rigor to game production: traceability, deterministic verification, failure-mode analysis, reproducible evidence, and explicit readiness gates.

This is an engineering discipline inspired by aerospace verification practice; it is not a claim of NASA certification.

---

# 1. Verification dimensions

Every production unit is evaluated across:

```text
FUNCTION
STATE
NAVIGATION
PRESENTATION
PERFORMANCE
RECOVERY
PERSISTENCE
COMPATIBILITY
REPRODUCIBILITY
```

A green visual screenshot cannot compensate for a broken state machine, and a successful compiler cannot compensate for broken gameplay.

---

# 2. Verification methods

Each requirement receives one or more methods:

- **I — Inspection:** resource graph, filenames, IDs, static config.
- **A — Analysis:** state-space, route graph, budget, dependency reasoning.
- **T — Test:** execute input and verify result.
- **D — Demonstration:** play the feature as a user would.
- **R — Regression:** repeat previously proven behavior after changes.

Example:

```text
REQ: Papa Wook visible after title transition
METHOD: I + T + R
EVIDENCE: scene resource + native screenshot + regression receipt
```

---

# 3. System readiness levels

## SRL-0 — Idea
No implementation.

## SRL-1 — Requirement
Experience and functional requirements written.

## SRL-2 — Architecture
State, resources, dependencies, and proof plan defined.

## SRL-3 — Native resource
GB Studio resources exist and validate.

## SRL-4 — Compiles
Native web and ROM build.

## SRL-5 — Functional slice
Critical path works locally.

## SRL-6 — Failure tested
Recovery, revisit, zero-resource, cancel/back, and boundary cases pass.

## SRL-7 — Presentation qualified
Visual/audio/HUD targets pass native screenshot/playtest QA.

## SRL-8 — Regression qualified
Adjacent maps and shared systems remain green.

## SRL-9 — Release proven
Hashed artifact, commit, receipt, and publication proof exist.

No chapter may be called complete below SRL-8.

---

# 4. Golden Campground master matrix

| Requirement | Method | Evidence | Release gate |
|---|---|---|---|
| Papa Wook visible | I/T/R | resource + screenshot | mandatory |
| four-direction movement | T/D | input run | mandatory |
| collision closed | A/T | route sweep | mandatory |
| Sniffany interaction | T/D | dialogue capture | mandatory |
| raccoon encounter | T/D | menu capture | mandatory |
| Crocs 0/2→2/2 state | T | state trace | mandatory |
| HUD accurate | T/D | screenshot | mandatory |
| inventory return behavior | T | menu test | mandatory |
| save/reload equivalence | T/R | before/after state | mandatory |
| no phone dependency softlock | A/T | battery-zero run | mandatory |
| native web build | T | artifact | mandatory |
| ROM build | T | WOOK.gb | mandatory |
| visual score >= target | D | scored screenshot | mandatory |

---

# 5. Route coverage

For each map, define graph nodes:

```text
SPAWN
LANDMARKS
QUEST NODES
OPTIONAL NODES
EXIT NODES
RECOVERY NODES
```

Then verify:
- spawn→critical objective,
- objective→exit,
- every mandatory node reachable,
- every exit escapable,
- optional branches return safely,
- revisits do not invalidate collision/state.

---

# 6. State-pair coverage

Important binary/multi-state combinations are explicitly tested.

Example Golden Campground:

```text
CROCS: 0 / 1 / 2
BATTERY: normal / zero
RACCOON: unresolved / resolved
SNIFFANY: unmet / met
QUEST: inactive / active / complete
```

Not every mathematical combination must be reachable. The architecture should identify valid and invalid combinations and test all valid critical-path combinations.

---

# 7. Save/reload matrix

Test saves at:
- map entry,
- before quest acquisition,
- after first quest item,
- before encounter,
- after encounter,
- before exit,
- after chapter transition.

Verify:

```text
NO_ITEM_DUPLICATION
NO_FLAG_REVERSION
NO_ACTOR_GHOSTING
NO_PLAYER_HIDDEN_STATE
NO_INVALID_SPAWN
NO_DUPLICATE_REWARD
```

---

# 8. Input matrix

Every screen tests:
- movement inputs,
- A confirm,
- B cancel,
- Start,
- Select where used,
- held input,
- repeated input,
- input during transition,
- input at collision boundary.

Menus require deterministic cancel/back semantics.

---

# 9. Dialogue verification

For every principal dialogue:

```text
NO_TEXT_CLIP
NO_OVERFLOW
NO_WRONG_PORTRAIT
NO_STALE_SPEAKER
NO_ACCIDENTAL_REPEAT
NO_BLOCKED_EXIT
```

Dialogue is tested at native resolution, not only as source text.

---

# 10. Character verification

Tier A/B characters test:
- silhouette identity,
- facing identity,
- animation continuity,
- portrait continuity,
- actor resource binding,
- map presence rules,
- dialogue state,
- chapter callbacks.

A character asset without a native actor or player binding is not implemented.

---

# 11. Dungeon verification

Every dungeon requires:
- room graph coverage,
- switch/key state table,
- reward uniqueness,
- exit reachability,
- revisit behavior,
- save/reload behavior,
- wrong-order puzzle attempts,
- backtracking,
- recovery route.

No dungeon may require a single undocumented state value to escape.

---

# 12. Performance verification

Record empirical output from the actual compiler/build:
- ROM size,
- compile success,
- warnings,
- tile pressure where observable,
- sprite/actor pressure where observable,
- audio footprint where observable,
- runtime behavior on native web and representative emulator/device.

Do not claim unused headroom without measurement.

---

# 13. Release Candidate protocol

An RC is created only when:

```text
STATIC_VALIDATION=PASS
NATIVE_WEB=PASS
ROM=PASS
CRITICAL_PATH=PASS
SAVE_MATRIX=PASS
SOFTLOCK_MATRIX=PASS
CHARACTER_CANON=PASS
HUD_MATRIX=PASS
AUDIO_SMOKE=PASS
VISUAL_QA=PASS
```

Then:
1. tag candidate commit,
2. hash artifacts,
3. run chapter regression,
4. run full-game smoke when available,
5. publish only if unchanged.

---

# 14. Defect severity

## S0 — Cosmetic
No gameplay/state consequence.

## S1 — Presentation
Readability, animation, audio, or composition defect.

## S2 — Functional minor
Optional feature broken; critical path intact.

## S3 — Functional major
Critical-path degradation with recovery available.

## S4 — Critical
Softlock, corrupted save, impossible progression, broken ROM, or invalid release artifact.

S4 blocks release automatically.
S3 blocks chapter qualification unless explicitly fixed.

---

# 15. Proof receipt schema

Every qualified packet should produce evidence equivalent to:

```json
{
  "packet": "WOOK-MAP-GA-001",
  "commit": "...",
  "requirements": {"passed": 42, "failed": 0},
  "build": {"web": "PASS", "rom": "PASS"},
  "recovery": "PASS",
  "save_reload": "PASS",
  "visual_qa": 9.4,
  "rom_sha256": "...",
  "result": "QUALIFIED"
}
```

A receipt records evidence; it does not create truth by itself.

---

# 16. Final mission success criteria

```text
GAME_BOOT=PASS
FULL_HERO_JOURNEY=PLAYABLE
ALL_CRITICAL_MAPS=SRL8+
ALL_DUNGEONS=SRL8+
CANONICAL_CAST=CONSISTENT
NO_KNOWN_S4_DEFECTS
SAVE_CONTINUITY=PASS
FULL_GAME_REGRESSION=PASS
ROM_REPRODUCIBLE=PASS
PUBLICATION_PROVEN=PASS
FINAL_OH=REACHABLE
```
