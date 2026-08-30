# WOOK — END-TO-END PRODUCTION LAW

Campaign: `WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001`

## Prime directive

WOOK production proceeds from the first red gate. Proven infrastructure is reused. No chapter, feature, art asset, script, build or screenshot can self-certify completion.

## Complete lifecycle

`MISSION INTENT → REQUIREMENTS → SYSTEM ARCHITECTURE → MAP/CONTENT DESIGN → RESOURCE CONTRACT → IMPLEMENTATION → STATIC VALIDATION → NATIVE BUILD → FUNCTIONAL TEST → INTEGRATION TEST → FAILURE/RECOVERY TEST → PRESENTATION QA → SAVE/RELOAD → REGRESSION → ARTIFACT HASH → RECEIPT → NEXT GATE`

## Requirement classes

- FUN — gameplay and game feel.
- VIS — visual presentation.
- AUD — music/SFX/ambience.
- NAR — narrative/dialogue/callbacks.
- SYS — state, items, economy, quests, affinity.
- MAP — topology, collision, routes, entrances/exits.
- CHR — character identity, sprite, animation, portraits.
- UI — HUD, menus, text, phone, inventory, map.
- PERF — memory, sprite/tile/ROM budgets and runtime behavior.
- SAFE — softlock prevention and recovery.
- BUILD — compiler and artifact production.
- PROOF — evidence, commit, hashes, receipts.

## Traceability law

Every critical requirement traces:

`REQ-ID → design element → repository resource/script → verification method → evidence → receipt`

A requirement without a verification method is incomplete. A PASS without evidence is not proof.

## Map lifecycle

L0 Experience Brief — why the map exists, intended feeling, objective, new mechanic, exit condition.

L1 Map Specification — dimensions, landmarks, actors, entrances/exits, collision topology, triggers, audio zones, secrets, quest hooks.

L2 State Contract — allowed entry states, mutations, persistence, recovery, impossible states.

L3 Art/Audio Contract — backgrounds, tiles, sprites, portraits, animation, palettes, foregrounds, music/SFX.

L4 Implementation — native GB Studio resources and scripts.

L5 Static Validation — JSON/resource validity, IDs, missing assets, duplicate symbols, reference integrity.

L6 Native Build — `make:web` and `make:rom` through the proven factory.

L7 Integration — spawn, movement, collision, actors, quest, dialogue, state, menus, exits.

L8 Failure Testing — wrong route, dead battery, missing optional item, repeated interaction, backtracking, menu cancel, save during transition, revisit after mutation.

L9 Presentation — native-resolution visual/audio/text/game-feel qualification.

L10 Proof — artifact, hash, commit, tests, receipt.

L11 Regression — replay every system sharing altered state/resources.

## Character lifecycle

Identity brief → silhouette → model sheet → overworld family → animation family → portrait family → signature behavior → resource binding → scene function → state callbacks → native build → screenshot/playtest → regression → receipt.

## Quest lifecycle

Intent → offer → accept/decline → active state → world mutation → objective → completion predicate → return/callback → reward → social/system consequence → persistence → later callback → proof.

## Dungeon lifecycle

Grammar → room graph → state graph → escalation → recovery topology → art/audio → implementation → route coverage → save/reload → no-softlock → presentation → receipt.

## Chapter lifecycle

Each C00–C15 chapter uses the default gates:

REQUIREMENTS → MAP_TOPOLOGY → CHARACTERS → CRITICAL_PATH → QUESTS → OPTIONAL_CONTENT → STATE → HUD_UI → AUDIO → SAVE_RELOAD → FAILURE_RECOVERY → NATIVE_WEB → ROM → VISUAL_QA → REGRESSION → RECEIPT.

A chapter cannot be called complete below SRL-8 (regression qualified). A chapter reaches SRL-9 only after release/publication proof for its approved release artifact when such publication is part of the milestone.

## Whole-game lifecycle

After C15 is functional, the work is not over. Gold requires:

1. all critical chapters SRL-8+;
2. whole-game route regression;
3. whole-game state regression;
4. whole-game save/load campaign;
5. all critical quest chains from fresh game through ending;
6. optional-content nonblocking verification;
7. dialogue/text-fit sweep at native resolution;
8. performance/budget audit;
9. reproducible native web build;
10. reproducible ROM build;
11. artifact hashes;
12. release commit;
13. publication proof;
14. final receipt.

Final result string: `WOOK_CARTRIDGE_CLASS_RELEASE_PASS`.

## No-sprint law

The project is not managed as a sequence of disconnected “sprints” that abandon unfinished integration debt. Work advances as a release train. Every chapter inherits the verified grammar and test burden of prior chapters. New work may not invalidate previous proofs without reopening the affected regression gates.

## No-fake-completion law

Architecture is SRL-2. Native resource creation is SRL-3. Compilation is SRL-4. Functional gameplay is SRL-5. These are achievements, not synonyms for finished. The controller reports the exact readiness state without promotional inflation.

## Platform law

WOOK GB remains the proven baseline. WOOK DX can become the primary production presentation only after controlled Golden Slice comparison. A future 16-bit renderer may reuse game truth but may not silently fork canon, IDs or state semantics.
