# WOOK-C0-HUD-MENU-001

## Mission

Instantiate the first real C0 interface runtime on top of the already-proven native GB Studio 4.3.2 project.

This packet owns four Golden Slice gates:

- `HUD`
- `PHONE`
- `INVENTORY`
- `QUEST_LOG`

It does not rebuild the toolchain and does not replace the campground scene. It extends the existing native scene graph.

## Native design

### Exploration HUD

Use GB Studio's native non-modal dialogue/overlay system at the top of the gameplay screen rather than a web-only DOM layer.

C0 display contract:

```text
BAT 17%  V 42  C 0/2
```

Backed by display-safe numeric global variables:

| ID | Name |
|---|---|
| `90` | C0 Crocs HUD Count |
| `91` | Battery |
| `92` | Vibes |
| `93` | Responsibility |
| `94` | Wook Karma |
| `95` | Groundscore |
| `96` | C0 UI Initialized |
| `97` | C0 Menu Choice |

The UUID-domain quest state remains canonical where already defined; numeric UI variables are presentation mirrors because GB Studio text interpolation accepts numeric variable IDs.

### Start

`START` pushes the current scene state and opens the WOOK C0 menu hub.

The hub offers:

```text
QUESTS
INVENTORY
PHONE
BACK
```

### Select

`SELECT` is the direct diegetic-phone shortcut.

### Quest Log

Must expose the active main quest and current Crocs count.

### Inventory

Must expose current Crocs count and Groundscore and establish the full-screen inventory return contract.

### Phone

Must expose Battery and the initial C0 phone functions while remaining non-critical-path safe.

## State initialization

On first C0 gameplay entry only:

```text
BATTERY=17
VIBES=42
RESPONSIBILITY=4
WOOK_KARMA=0
GROUNDSCORE=0
UI_INITIALIZED=1
```

Revisiting the scene must not reset state.

## Crocs HUD mirror

The Crocs packet remains authoritative for quest completion. It also increments numeric variable `90` as the presentation mirror so the exploration HUD and menu pages can display `0/2 -> 1/2 -> 2/2` using GB Studio-native text interpolation.

## Resource contract

The implementation packet creates:

```text
game/project/project/scripts/wook/ui/init_wook_ui.gbsres

game/project/project/scenes/ui/wook_menu/scene.gbsres
game/project/project/scenes/ui/wook_phone/scene.gbsres
game/project/project/scenes/ui/wook_inventory/scene.gbsres
game/project/project/scenes/ui/wook_quest_log/scene.gbsres

game/project/assets/backgrounds/wook-ui-menu.png(.gbsres)
game/project/assets/backgrounds/wook-ui-phone.png(.gbsres)
game/project/assets/backgrounds/wook-ui-inventory.png(.gbsres)
game/project/assets/backgrounds/wook-ui-quest-log.png(.gbsres)
```

and patches:

```text
game/project/project/variables.gbsres
game/project/project/scenes/questionable_campground/scene.gbsres
```

## Verification

Static:

```text
DISPLAY_VARIABLES=PASS
HUD_EVENT=PASS
START_INPUT_ROUTE=PASS
SELECT_PHONE_ROUTE=PASS
MENU_SCENE=PASS
PHONE_SCENE=PASS
INVENTORY_SCENE=PASS
QUEST_LOG_SCENE=PASS
CROCS_HUD_MIRROR=PASS
```

Native:

```text
GB_STUDIO_NATIVE_WEB=PASS
GB_STUDIO_ROM=PASS
```

Receipt:

`docs/proof/receipts/C0-HUD-MENU-LATEST.json`

Result:

`WOOK_C0_HUD_MENU_NATIVE_PASS`

Visual qualification remains separately reviewable against the Cartridge-Class visual contract; this packet proves native runtime presence and behavior, not final art-direction perfection.
