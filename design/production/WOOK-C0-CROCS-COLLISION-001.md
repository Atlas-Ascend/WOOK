# WOOK-C0-CROCS-COLLISION-001

## Mission

Convert the C0 Crocs joke into a deterministic native quest-state chain and convert The Questionable Campground from an illustration with empty collision data into a route-qualified playable topology.

## Frozen inputs

- proven GB Studio 4.3.2 compiler factory;
- native 20x18 Questionable Campground scene;
- Papa Wook / Sniffany / raccoon character layer;
- Handstand Dan C0 packet;
- C0 map and SDLC contracts.

The packet does not rebuild the toolchain.

## State

Stable C0 variables:

```text
C0 Croc Left Found
C0 Croc Right Found
C0 Crocs Count
C0 Raccoon Resolved
C0 Venue Ready
C0 Shoes Quest Complete
```

The native variables resource is normalized to GB Studio 4.3.2's array schema without deleting pre-existing variable definitions.

## Pickup grammar

### Left Croc

Normal exploration pickup:

```text
INTERACT
→ guard against duplicate pickup
→ item-found text
→ left-found=true
→ crocs-count++
→ completion check
→ actor deactivates
```

### Right Croc

Raccoon-gated pickup:

```text
INTERACT
→ already-found guard
→ raccoon-resolved?
   ├─ NO → claimed-Croc text
   └─ YES → pickup → count++ → completion check → deactivate
```

If the raccoon actor from the prior character packet exists, this packet appends the deterministic `raccoon_resolved=true` mutation after the encounter.

## Completion

When `crocs_count >= 2`:

```text
shoes_quest_complete=true
venue_ready=true
WHERE ARE MY SHOES? COMPLETE!
CROCS 2/2
```

The GA exit remains geometrically reachable but narrative transition to the next map is left for the dedicated GA-map packet rather than creating a broken target scene.

## Collision topology

The scene is 20x18 tiles. Collision data uses the GB Studio four-direction blocking mask `0x0F` and is encoded with GB Studio's native 8-bit run-length resource format.

Obstacle families:
- world borders with an authored south exit aperture;
- van;
- north tent;
- west sign;
- campfire;
- altar/cooler cluster.

The logical topology lives in:

`design/gameplay/C0-CAMPGROUND-TOPOLOGY.json`

The packet must prove four-neighbor route connectivity for:

```text
spawn → Sniffany
spawn → Croc Left
Croc Left → raccoon
raccoon → Croc Right
Croc Right → GA exit
spawn → Handstand Dan
Handstand Dan → GA exit
```

This makes collision changes regression-testable rather than purely visual.

## Implementation

```bash
bash scripts/implement-c0-crocs-collision-001.sh
```

Pipeline:

```text
PRESERVE PROJECT
↓
BUILD COLLISION GRID
↓
ROUTE BFS
↓
WRITE NATIVE COLLISION STRING
↓
MATERIALIZE C0 VARIABLES
↓
MATERIALIZE CROC PICKUP RESOURCES
↓
PATCH RACCOON RESOLUTION
↓
STATIC AUDIT
↓
make:web
↓
make:rom
↓
HASH
↓
RECEIPT
```

## Proof

Static packet proof:

`WOOK_C0_CROCS_COLLISION_STATIC_AUDIT=PASS`

Native execution proof:

`WOOK_C0_CROCS_COLLISION_NATIVE_PASS`

Native gameplay/playtest qualification remains separate; compiler success alone does not prove that the pickup cadence, collision feel, or quest presentation are cartridge-class.

## Next seam

After native/playtest proof, the next C0 subsystem is the integrated HUD + Phone + Inventory + Quest Log layer.
