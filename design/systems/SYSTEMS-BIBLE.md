# Systems Bible

## Global variables
G_ACT, G_BATTERY, G_VIBES, G_GROUNDSCORE, G_RESPONSIBILITY, G_WOOK_KARMA, G_CASH, G_CROCS, G_PHONE_UNLOCKED, G_SAVE_VERSION

## Shared custom events
CE_ADD_VIBES
CE_ADD_KARMA
CE_ADD_RESPONSIBILITY
CE_BATTERY_DRAIN
CE_GROUNDSCORE
CE_QUEST_UPDATE
CE_STATUS_TOAST
CE_PHONE_OPEN
CE_PHONE_CLOSE
CE_ENCOUNTER
CE_INVENTORY_ADD
CE_INVENTORY_REMOVE
CE_SAVE_CHECKPOINT

## Proof invariants
Battery clamps 0..100.
Vibes and Karma retain signed values.
Responsibility never decreases from compassionate actions.
Quest state transitions are monotonic unless explicitly authored as reversible.
Every scene transition has a destination and spawn contract.
