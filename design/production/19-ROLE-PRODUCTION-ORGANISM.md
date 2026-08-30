# WOOK — 19-ROLE PRODUCTION ORGANISM

Campaign: `WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001`

This is a responsibility architecture, not nineteen isolated people. One human or agent may hold several roles, but every release decision must be attributable to a role and every critical gate must have an owner.

## R01 — Executive Producer / Canon Keeper
Owns scope, canon, release intent, priority conflicts, canon freeze and anti-drift law. Prevents replacement architectures from silently superseding proven work.

Outputs: canon decisions, scope decisions, chapter release authorization, exception records.

## R02 — Game Director
Owns player experience, pacing, controls, game feel, difficulty curve, authored surprise, and the cartridge-quality bar.

Outputs: experience briefs, play-feel acceptance, chapter pacing signoff.

## R03 — Narrative Director
Owns Hero's Journey, character voice, dialogue, callbacks, emotional pacing, comedy, Ordeal meaning, goodbye sequence, cosmic integration, and `OH.`

Outputs: narrative state graph, dialogue source, callback matrix, chapter narrative acceptance.

## R04 — Systems Architect
Owns Battery, Vibes, Responsibility, Wook Karma, Groundscore, Cash/Trade, Inventory, Quests, Affinity, Reality Stability, schedule semantics and interaction contracts.

Outputs: state schemas, mutation law, cross-system invariants.

## R05 — World / Level Director
Owns topology, traversal, landmarks, persistent geography, entrances/exits, secrets, route readability, crowd routing and state-dependent map variants.

Outputs: map briefs, route graphs, landmark contracts, collision intent.

## R06 — Dungeon Designer
Owns Porta-Potty Labyrinth, Totem Forest, Memory Constellation and any minor challenge spaces. Every dungeon must own a distinct grammar and recovery topology.

Outputs: room graph, puzzle state graph, escalation curve, boss-equivalent design, recovery paths.

## R07 — Character Director
Owns Papa Wook, Sniffany, Train Station, Loki, The Wizard, Bufo D' Clown, Handstand Dan, recurring secondary cast and reserve casting. Controls silhouette, role, relationship function, signature behavior and dialogue continuity.

Outputs: character bibles, fidelity tier, relationship hooks, actor acceptance.

## R08 — Pixel Art Director
Owns backgrounds, tiles, palettes, props, foregrounds, environmental storytelling, map-state variants, item art and cartridge readability.

Outputs: art contracts, tile budgets, map visual qualification.

## R09 — Animation Director
Owns player locomotion, idle cycles, contextual poses, reactions, NPC signature animation, item pickup ceremonies, quest-complete sequences and crowd animation budgets.

Outputs: animation lists, timing contracts, native animation QA.

## R10 — UI / HUD Director
Owns EXPLORATION, VENUE, DUNGEON, ENCOUNTER, MINIGAME, QUIET, CUTSCENE and COSMIC HUD modes plus Phone, Inventory, Quest Log, People, Map, Weekend and text composition.

Outputs: UI state machine, menu flows, text-fit proofs, HUD screenshots.

## R11 — Audio Director
Owns score, SFX, venue-distance layers, stage themes, ambient beds, silence, motif transformation, alternate-reality audio and cosmic integration.

Outputs: cue sheet, music-state map, SFX grammar, audio regression list.

## R12 — Gameplay Engineer
Owns player control, interactions, event logic, encounters, minigames, item use, input mapping, deterministic outcomes and moment-to-moment implementation.

Outputs: gameplay resources/scripts, functional tests, controller-feel proof.

## R13 — GB Studio Integration Engineer
Owns `.gbsres` resource correctness, actors, scenes, scripts, backgrounds, avatars, variables, compiler compatibility and native Game Boy constraints.

Outputs: resource graph, native build readiness, migration-safe bindings.

## R14 — State / Save Engineer
Owns save schema, versioning, stable IDs, checkpoint policy, one-time guards, persistence, reload equivalence and state migration.

Outputs: save matrix, persistence tests, duplication prevention evidence.

## R15 — Build / Release Engineer
Owns `make:web`, `make:rom`, reproducibility, artifact collection, ROM/web hashes, publication, release candidates, rollback boundaries and final packaging.

Outputs: native artifacts, build logs, hashes, RC receipts, release receipt inputs.

## R16 — QA / Test Engineer
Owns functional, integration, map-route, dialogue, menu, quest, item, encounter, save/load, cross-chapter and whole-game regression testing.

Outputs: test matrix, defect record, regression evidence.

## R17 — Failure / Recovery Engineer
Owns softlock analysis, dead-phone recovery, missing-item recovery, alternate routes, fault injection, repeat-order tests, interrupted transitions and impossible-state prevention.

Outputs: FMEA-style risk table, recovery tests, critical-path resilience proof.

## R18 — Performance / Cartridge Engineer
Owns sprite/tile/memory budgets, scene complexity, animation load, ROM size, performance, Game Boy/DX constraints and platform-specific optimization.

Outputs: budget reports, hotspot analysis, performance qualification.

## R19 — Proof / Configuration Manager
Owns requirement IDs, traceability, evidence locations, commit IDs, hashes, SRL status, branch truth, first-red-gate reporting and release qualification.

Outputs: state files, receipts, proof index, release truth.

# Handoff law

Every work packet declares its primary role and required reviewers. No role can self-certify every dimension of a critical release gate. Implementation evidence flows to QA; QA evidence flows to Proof/Configuration; release artifacts flow through Build/Release; canon and experience acceptance remain explicit.

# Chapter staffing law

Every C00–C15 packet must have at minimum:

- R02 experience owner;
- R03 narrative owner;
- R04 systems owner;
- R05 map owner;
- R07 character owner;
- R10 UI owner;
- R11 audio owner;
- R12 gameplay owner;
- R13 engine owner;
- R14 save owner;
- R16 QA owner;
- R17 recovery owner;
- R19 proof owner.

R01, R06, R08, R09, R15 and R18 participate when scope, dungeons, art, animation, release or budgets are touched—which is most chapters.

# Command-to-proof responsibility chain

`INTENT → REQUIREMENT → DESIGN → RESOURCE → IMPLEMENTATION → BUILD → TEST → FAILURE TEST → PRESENTATION QA → REGRESSION → HASH → RECEIPT → NEXT RED GATE`

No role may convert “looks right” into PASS without evidence.