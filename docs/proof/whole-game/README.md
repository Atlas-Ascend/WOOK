# WOOK — WHOLE-GAME PROOF AREA

Runtime-generated evidence for `WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001` belongs here.

Expected runtime objects:

- `state.json` — controller truth for C00–C15;
- `work-packets/CXX-WORK-PACKET.json` — prepared chapter contracts;
- `WHOLE-GAME-REGRESSION.json` — explicit final whole-game regression evidence;
- `WOOK-WHOLE-GAME-RELEASE-<timestamp>.json` — immutable release receipt;
- `LATEST.json` — pointer/copy of the latest Gold receipt after final qualification.

## Required whole-game regression evidence shape

```json
{
  "schema": "ghost-atlas.wook.whole-game.regression.v1",
  "proof": {
    "route": "PASS",
    "state": "PASS",
    "save_reload": "PASS",
    "dialogue": "PASS",
    "ui": "PASS",
    "dungeons": "PASS",
    "failure_recovery": "PASS",
    "performance": "PASS",
    "presentation": "PASS"
  },
  "open_blockers": 0,
  "result": "PASS"
}
```

The controller deliberately does not create this file automatically. Whole-game regression must be earned by the corresponding tests.

## Evidence law

Receipts describe observed proof. They do not convert architecture into implementation. Manual edits to a proof file without corresponding artifact/test evidence are not accepted as engineering proof.
