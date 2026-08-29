# GB Studio Architecture

## Canonical editable source
`game/project/WOOK.gbsproj`

## Version strategy
The campaign builds a schema-compatible project manifest and then asks the installed GB Studio CLI to compile it. A compile is the authoritative proof; JSON existence alone is not.

## Scene graph
S00_TITLE
S01_QUESTIONABLE_CAMPGROUND
S02_MOONBEAM_ALTAR
S03_PHONE_UI
S04_RACCOON_ENCOUNTER
S05_FESTIVAL_GATE

## Event graph
Title: await input -> switch to Campground
Campground init: set starting globals -> opening dialogue
Croc A: interact -> increment Crocs -> Groundscore toast
Jessica: dialogue -> unlock altar Croc
Croc B: interact -> increment Crocs -> check Crocs
Phone: menu input -> phone scene/overlay
Raccoon: trigger -> encounter scene -> choice -> state consequences
Gate: if Crocs == 2 -> festival gate else refusal dialogue

## Runtime truth
`gb-studio-cli make:web` and `make:rom` must both succeed before the native GB Studio build is marked PASS.
