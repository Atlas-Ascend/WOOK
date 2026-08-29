# ADR — WOOK ROM / Platform Upgrade Strategy

**Status:** PROPOSED-FOR-FREEZE  
**Current proven runtime:** GB Studio 4.3.2 native web + Game Boy ROM  
**Current production mode:** monochrome Game Boy presentation  

---

# 1. Problem

WOOK now has two simultaneous product goals:

1. remain a real cartridge-authentic game with a proven native ROM pipeline;
2. reach the visual, systemic, and authored quality associated with top-tier Nintendo-era adventure software.

The second goal must not be confused with literal hardware equivalence. Original Game Boy hardware cannot reproduce SNES color depth, resolution, sprite throughput, or audio hardware.

Therefore the upgrade decision is about **production fidelity and target hardware**, not simply drawing more detailed sprites.

---

# 2. Current ROM lane

The current lane remains valuable and must be preserved:

```text
WOOK V4
↓
GB Studio 4.3.2
↓
Game Boy native build
↓
WOOK.gb
↓
web emulator export
```

This is the compatibility / authenticity baseline.

It should never be deleted merely because a richer target is introduced.

---

# 3. Recommended product family

## Lane A — WOOK GB

**Purpose:** authentic monochrome cartridge baseline.

Target feel:
- Link's Awakening-era discipline,
- Super Mario Land 2-era clarity,
- compact authored maps,
- strong silhouettes,
- dense systems despite hardware limits.

This lane is already proven technically.

## Lane B — WOOK DX

**Recommended next upgrade.**

A Game Boy Color-oriented production target using the existing GB Studio project lineage where feasible.

Goals:
- richer per-scene palette design,
- stronger character separation,
- more readable venue spectacle,
- day/night palette shifts,
- improved dungeon identities,
- better UI hierarchy,
- preserve cartridge authenticity.

WOOK DX is an upgrade lane, not a rewrite of the narrative/state architecture.

## Lane C — WOOK 16 / Modern Cartridge-Class Port

If the requirement becomes **literal SNES-class rendering**, create a separate renderer/backend rather than forcing Game Boy hardware to imitate capabilities it does not have.

Possible future targets:
- actual SNES homebrew toolchain,
- modern 2D engine with strict 16-bit presentation constraints,
- desktop/mobile/web port driven by the same content/state contracts.

This is a port, not a replacement for WOOK GB/DX.

---

# 4. Shared-content architecture

The long-term system should separate game truth from renderer truth.

```text
CANON
├── characters
├── dialogue
├── quests
├── world-state schema
├── maps / logical zones
├── items
├── schedules
└── narrative flags

        ↓

PLATFORM ADAPTERS
├── GB adapter
├── GBC/DX adapter
└── future 16-bit adapter
```

This prevents a future platform upgrade from requiring the entire story and quest system to be redesigned.

---

# 5. What remains shared

Across GB, DX, and future ports:
- Papa Wook identity
- canonical cast
- reserve roster
- hero's-journey spine
- chapter order
- quest IDs
- item IDs
- world-state semantics
- dialogue source
- dungeon logic
- acceptance requirements
- SDLC proof model

---

# 6. What is platform-specific

### GB
- four-shade art treatment
- tile/sprite budgets
- monochrome UI
- GB audio arrangement

### DX / GBC
- palette assignments
- day/night color scripts
- enhanced portrait and environment palette treatment
- GBC-specific presentation choices

### 16-bit / modern port
- higher-resolution tile sets
- expanded animation frames
- richer particles/lighting
- larger crowds
- more layered audio
- platform-specific controls

---

# 7. Upgrade sequence

Do not jump platform before proving the opening gameplay loop.

Recommended order:

```text
1. FINISH GOLDEN CAMPGROUND ON CURRENT GB LANE
2. PROVE PAPA / SNIFFANY / HUD / QUEST / RACCOON / COLLISION
3. FREEZE GAMEPLAY CONTRACT
4. CREATE DX EXPERIMENT BRANCH
5. COLORIZE THE SAME GOLDEN SCENE
6. COMPARE GB vs DX
7. CHOOSE PRIMARY SHIPPING TARGET
8. PROPAGATE THE WINNER ACROSS THE FULL GAME
```

This keeps the platform decision evidence-based.

---

# 8. Decision recommendation

**Primary recommendation:** preserve WOOK GB as the proven baseline and develop **WOOK DX** as the next visual target once the Golden Campground gameplay slice is cartridge-class complete.

Why:
- least architecture churn,
- preserves real cartridge identity,
- materially improves character/environment readability,
- supports day/night/festival spectacle better than monochrome,
- avoids prematurely rebuilding the game in a new engine.

If later testing shows the creative target still demands literal SNES-scale capabilities, create WOOK 16 as a port using the same canon/state/quest architecture.

---

# 9. Non-regression requirement

A platform upgrade may not invalidate:
- current ROM reproducibility,
- canonical state IDs,
- quest IDs,
- chapter structure,
- dialogue source,
- test matrices,
- command-to-proof receipts.

Every new backend must prove parity on the Golden Scene before it can become primary.

---

# 10. Platform acceptance comparison

| Capability | WOOK GB | WOOK DX | WOOK 16 |
|---|---|---|---|
| Real cartridge authenticity | maximum | maximum | target-dependent |
| Existing compiler proven | yes | largely reusable path | no |
| Color richness | low | medium/high | high |
| Animation budget | constrained | constrained | much higher |
| Crowd spectacle | constrained | constrained | higher |
| Migration cost | none | low/moderate | high |
| Risk | low | moderate | high |

The architecture therefore treats DX as the rational next experiment and WOOK 16 as an optional later port.
