# ACT 03 — THE PARKING LOT

## Core Question
**Where Is The Car?**

## Narrative Function
Spatial memory, vehicle clues, battery pressure, Space Dave.

## GB Studio Production Package
Each act is implemented as a scene cluster with:
- exploration scenes
- dialogue scenes
- encounter scenes
- phone/quest overlays
- scene-local variables
- global state callbacks
- custom events for shared systems
- explicit entrance/exit proof points
- visual acceptance captures against the canonical WOOK contract

## Exit Proof
An act is complete only when its main quest state reaches COMPLETE, required callbacks are written, and the next act transition is reachable in a clean save.
