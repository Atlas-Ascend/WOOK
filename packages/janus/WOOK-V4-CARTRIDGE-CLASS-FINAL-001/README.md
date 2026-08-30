# WOOK V4 — JANUS In-Repo Package

Package: `WOOK-V4-CARTRIDGE-CLASS-FINAL-001`

This directory is the JANUS/Termux entry point for the Cartridge-Class production branch. The canonical product truth remains in `design/`; this package references it rather than copying it.

## Canonical inputs

- `design/production/WOOK-CARTRIDGE-CLASS-FINAL-PACKAGE.md`
- `design/production/WOOK-SDLC-COMMAND-TO-PROOF.md`
- `design/gameplay/WOOK-FULL-GAMEPLAY-MAP-BY-MAP.md`
- `design/systems/WOOK-HUD-STATE-RUNTIME-ARCHITECTURE.md`
- `design/qa/WOOK-AEROSPACE-GRADE-VERIFICATION-MATRIX.md`
- `design/platform/WOOK-ROM-PLATFORM-UPGRADE-ADR.md`
- `design/characters/CANONICAL-CAST-LAW.md`
- `design/characters/WOOKIE-RESERVE-ROSTER.md`

## JANUS

From a checkout of `architecture/character-detail-level10`:

```bash
bash packages/janus/WOOK-V4-CARTRIDGE-CLASS-FINAL-001/RUN-JANUS.sh
```

Then:

```bash
bash packages/janus/WOOK-V4-CARTRIDGE-CLASS-FINAL-001/START-C0-GOLDEN-SLICE.sh
```

## Production truth

The existing GB Studio/native ROM factory is proven. The full C0→C15 Cartridge-Class game is architected but not yet fully implemented. The current production seam is C0.

No package script may silently reset a dirty checkout, rebuild the proven toolchain without a failed diagnostic, or mark unexecuted gameplay as PASS.
