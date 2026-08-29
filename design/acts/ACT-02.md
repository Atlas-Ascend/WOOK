# ACT 02 — THE FESTIVAL

## Core Question
**Where Is Everyone?**

## Narrative Function
Crowds, stages, rumors, friend-finding, sound bleed, side quests.

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
