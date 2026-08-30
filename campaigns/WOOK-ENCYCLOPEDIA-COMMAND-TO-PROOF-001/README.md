# WOOK — ENCYCLOPEDIA COMMAND TO PROOF

Campaign: `WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001`

This campaign owns the complete production train from the existing proven native WOOK baseline through C00 `WHERE ARE MY SHOES?` and all the way to C15 `OH.` and final Gold qualification.

## Production philosophy

No more disconnected sprint logic. The game advances as one release train. Every new system inherits the regression burden of the systems already proven.

The controller always reports the first red chapter/gate. It may invoke a concrete implementation packet when one exists. When native implementation does not yet exist, it creates the exact chapter work packet and stops truthfully at `IMPLEMENTATION_PACKET_REQUIRED` rather than manufacturing a fake PASS.

## Commands

```bash
cd "$HOME/.ghost-atlas/games/WOOK"

git fetch origin
git switch architecture/character-detail-level10
git pull --ff-only

bash scripts/wook-encyclopedia-controller.sh audit
bash scripts/wook-encyclopedia-controller.sh status
bash scripts/wook-encyclopedia-controller.sh next
bash scripts/wook-encyclopedia-controller.sh run
```

### Audit

Validates the encyclopedia files, machine-readable campaign, exactly 19 production roles, exactly 16 chapters, and shell syntax.

### Status

Reports C00–C15 readiness and the first red gate.

### Next

Reports the next chapter, gate, mission, maps, core roles and packet command.

### Run

For C00, routes into the existing Golden Slice controller and its concrete native packets.

For C01–C15, runs `scripts/implement-cXX.sh` when such a native implementation packet exists. Otherwise it prepares an immutable chapter work packet and stops at the implementation boundary.

### Report

```bash
bash scripts/wook-encyclopedia-controller.sh report
```

Emits the whole-game state JSON.

### Prove

```bash
bash scripts/wook-encyclopedia-controller.sh prove
```

This can succeed only after all chapters are qualified and whole-game regression evidence exists. It then verifies the current native ROM and web artifact, hashes them and writes the final release receipt.

## Final result

The only final whole-game PASS string is:

`WOOK_CARTRIDGE_CLASS_RELEASE_PASS`

Anything before that is an explicit readiness state, not a euphemism for finished.
