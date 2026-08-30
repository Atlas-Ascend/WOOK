# WOOK-C0-REGRESSION-001 — GOLDEN CAMPGROUND INTEGRATION REGRESSION

Campaign: `WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001`
Chapter: `C00 — WHERE ARE MY SHOES?`
Gate: `REGRESSION`

## Preconditions

All C00 gates through `VISUAL_QA` must already be PASS.

## Required evidence families

- character Golden receipt;
- Handstand Dan receipt;
- Crocs/collision receipt;
- HUD/menu receipt;
- state-mutations receipt;
- side-quest receipt;
- secret receipt;
- save/reload native-path receipt;
- GA-exit receipt;
- visual QA state/evidence.

## Regression work

1. rerun static audits for every C00 native packet;
2. validate C00 state ledger has no earlier red gate;
3. perform one final integrated `make:web`;
4. perform one final integrated `make:rom`;
5. verify current native web and ROM exist;
6. hash integrated artifacts;
7. verify C01 remains an entry seam and is not marked qualified by C00;
8. create `C0-REGRESSION-LATEST.json`.

## Behavioral matrix

The native playtest preceding regression must cover the critical C00 route and representative recovery/order variants. The regression script validates evidence/state and performs final compilation; it does not invent human gameplay evidence.

## Pass result

`WOOK_C0_REGRESSION_PASS`