# WOOK — WHOLE-GAME RELEASE QUALIFICATION

## Release truth

A green chapter receipt proves that chapter's defined acceptance scope. It does not automatically prove the rest of the game. Gold is a separate whole-game campaign.

## Critical whole-game matrices

### Route matrix
Verify every mandatory transition from new game through C15, every critical recovery route, every dungeon entrance/exit, every chapter boundary, every persistent-world revisit, every supported optional detour return path and every final-state route home.

### State matrix
Verify Battery, Vibes, Responsibility, Wook Karma, Groundscore, Cash/Trade, Inventory, quest families, affinity, Reality Stability, festival day/daypart, dungeon state, world mutations and one-time rewards across chapter transitions.

### Save/load matrix
Save and reload at: map entry, before quest acquisition, after first quest item, before/after encounter, dungeon entry, dungeon midpoint when supported, dungeon completion, day transition, 4 AM, Ordeal start/end, final-day transition, road-home start, before Memory Constellation and before final home scene.

Blockers: item duplication, flag reversion, actor ghosting, invisible player state, invalid spawn, duplicate rewards, impossible quest state, stale menu state, corrupted world phase, unrepeatable final route.

### Dialogue matrix
NO_TEXT_CLIP; NO_OVERFLOW; NO_WRONG_PORTRAIT; NO_STALE_SPEAKER; NO_ACCIDENTAL_REPEAT; NO_BLOCKED_EXIT; NO_DEPRECATED_ACTIVE_CAST_NAME; all critical dialogue pages readable at native resolution.

### Character matrix
Papa Wook: Tier-A silhouette, four-direction identity, locomotion, context poses, portraits, late-game continuity.

Principal cast: distinct silhouette, signature animation/pose, portrait/dialogue identity, state callback and chapter function.

Supporting cast: no default template art in qualified scenes.

### Dungeon matrix
Porta-Potty Labyrinth: route graph, reset behavior, switch state, Loki/Wizard branch safety, reward guard, impossible shortcut landing.

Totem Forest: landmark visibility/occlusion, audio cues, alternate route, save/reload, exit return.

Memory Constellation: state-driven rooms, no trivia-only mandatory gates, supported end-state families, home return.

### HUD/UI matrix
All eight modes: EXPLORATION, VENUE, DUNGEON, ENCOUNTER, MINIGAME, QUIET, CUTSCENE, COSMIC.

Verify menu return, Phone direct access, dead-phone fallback, Inventory accuracy, Quest Log accuracy, People/Affinity when exposed, Map/Weekend state, text fit and quiet-scene restraint.

### Audio matrix
Cue correctness, no missing critical SFX, venue-distance progression, music transitions, silence timing, alternate-reality motif mutation, final-set convergence, road/cosmic transformation and final-home return.

### Failure/recovery matrix
Test dead phone, zero water, insufficient cash, missing optional Groundscore item, low affinity, low Responsibility, low Wook Karma, abandoned optional quest, alternate order, repeated actor interaction, revisits, boundary collision, menu cancellation, save/reload during state transition and optional-route miss.

Critical progression must never depend on a single fragile optional state without a recovery route.

### Performance/cartridge matrix
Scene sprite budget, tile budget, animation load, background complexity, audio load, ROM size, compile time warnings, runtime slowdown, visual corruption and platform-specific constraints.

## Visual qualification target

- player control/readability: 10/10 target;
- character silhouettes: 10/10;
- animation: 9+/10;
- world density: 10/10 target;
- level design: 9+/10;
- UI composition: 10/10 target;
- dialogue presentation: 9+/10;
- environmental storytelling: 10/10 target;
- native authenticity: 10/10;
- target-board coherence: 9+/10.

Scores do not replace functional gates.

## Release-candidate sequence

RC0: all chapters functionally complete and no known blocker-class softlock.

RC1: whole-game route/state/save regression completed; critical bugs repaired.

RC2: presentation/audio/performance sweep completed; no release-blocking regression.

GOLD CANDIDATE: deterministic web/ROM build from clean checkout; hashes captured; final playthrough green.

GOLD: release commit fixed; public artifacts verified; final receipt emitted.

## Final receipt contract

The final receipt records at minimum:
- campaign;
- timestamp;
- release commit;
- platform/edition;
- ROM hash;
- native web hash;
- chapter receipt index;
- whole-game route result;
- whole-game state result;
- whole-game save/load result;
- presentation result;
- regression result;
- publication result;
- open blocker count = 0;
- result = `WOOK_CARTRIDGE_CLASS_RELEASE_PASS`.

Anything less is a readiness milestone, not Gold.