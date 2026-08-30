# WOOK-C0-SAVE-RELOAD-001 — CAMPFIRE CHECKPOINT

Campaign: `WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001`
Chapter: `C00 — WHERE ARE MY SHOES?`
Primary gate: `SAVE_RELOAD`

## Mission

Introduce one native Game Boy save/check/load checkpoint into the Golden Campground using GB Studio's stock save-data events and prove that C00 state has a cartridge-backed persistence path.

## Native basis

The packet uses GB Studio 4.3's built-in event IDs:

- `EVENT_SAVE_DATA`
- `EVENT_LOAD_DATA`
- `EVENT_IF_SAVED_DATA`

WOOK currently uses MBC5 with `batterylessEnabled=false`, which preserves the battery-backed cartridge path required by the stock save system.

## Campfire checkpoint

Interaction menu:

```text
CAMPFIRE CHECKPOINT

SAVE
LOAD
CANCEL
```

SAVE writes slot 0 and confirms completion.

LOAD first checks whether slot 0 contains compatible data. If so it loads. If not, it returns a nonfatal `NO SAVE YET` message.

## C00 persistence matrix

Manual/native qualification later must test saves at minimum after:

1. initial campground entry;
2. one Croc obtained;
3. raccoon resolved;
4. Pashmina side quest accepted;
5. Pashmina found;
6. Pashmina returned;
7. van secret claimed;
8. both Crocs obtained;
9. immediately before GA exit.

For each checkpoint, reload must preserve relevant quest/item/system flags without duplicate rewards or hidden-player/spawn corruption.

## Static/native acceptance

- settings remain battery-capable;
- save point native actor exists;
- stock save event exists;
- saved-data guard exists;
- stock load event exists;
- native web compiles;
- native ROM compiles;
- packet receipt is `WOOK_C0_SAVE_RELOAD_NATIVE_PATH_PASS`.

The packet receipt proves a native save/load path exists and compiles. The later C00 regression gate performs the full behavioral save/reload matrix before Golden Slice qualification.