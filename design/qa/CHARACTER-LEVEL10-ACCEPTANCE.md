# WOOK Character Level-10 Acceptance

This document converts "the characters need detail" into measurable production gates.

---

## 1. Hero acceptance — Papa Wook

### Silhouette
- recognizable without interior color
- hat, eyewear, beard, torso layering, pack, stance all readable
- no generic GB Studio player silhouette visible in approved footage

**Required:** 10/10

### Directional identity
- up/down/left/right all still read as Papa Wook
- rear view preserves hat, pack, coat silhouette
- side view preserves nose/beard/hat geometry without collapsing

**Required:** PASS

### Locomotion
- leg contact visibly changes
- arm swing or torso counter-motion visible
- pack/coat secondary motion readable
- no "sprite slides while bobbing" behavior

**Required:** >= 9/10

### Context poses
Required native demonstrations:
- phone
- item acquisition
- campfire sit
- negotiation
- victory

**Required:** PASS

### Portraits
- at least eight clearly distinguishable expressions
- identity consistency across all portraits
- eyes/mouth/brow/beard geometry support expression
- portrait framing survives actual dialogue composition

**Required:** 10/10

---

## 2. Principal NPC acceptance

For Jessica, Trevor, Trent, Space Dave, Solar Charger Guy:

### Required
- silhouette distinct from Papa Wook and from each other
- one signature prop or costume cue
- one signature animation
- four portrait expressions minimum for Tier B
- dialogue portrait instantiated in native build
- actor visible and interactable in at least one native scene

### Rejection conditions
- recolor-only differentiation
- same body with swapped hat and no other identity change
- portrait unrelated to overworld silhouette
- final scene using template/default actor

---

## 3. Raccoon encounter acceptance

### Map form
- readable masked face
- tail silhouette readable
- alert idle motion

### Encounter form
- larger dedicated art
- readable face/body/tail detail
- menu composed with four canonical verbs
- visual response after selection

**Required:** 10/10 silhouette, >=9/10 encounter composition

---

## 4. Dialogue acceptance

Every principal-character dialogue screen must pass:

```text
NO_TEXT_CLIPPING
NO_UNINTENTIONAL_WRAP
NO_DIALOGUE_OVERFLOW
PORTRAIT_VISIBLE
SPEAKER_IDENTITY_CLEAR
ADVANCE_TIMING_AUTHORED
```

Comedy timing is evaluated as part of layout.

---

## 5. Golden Scene character proof board

A native screenshot set must contain:

1. Papa Wook walking in campground
2. Papa Wook facing all four directions
3. Jessica interaction with portrait
4. raccoon map actor
5. raccoon encounter
6. Croc item acquisition pose
7. quest completion / victory pose
8. phone pose or phone transition

The set is compared against the canonical WOOK visual boards.

---

## 6. Scoring matrix

| Dimension | Weight | Minimum |
|---|---:|---:|
| Silhouette readability | 20% | 10/10 |
| Overworld character detail | 15% | 9/10 |
| Portrait expressiveness | 15% | 9/10 |
| Animation quality | 15% | 9/10 |
| Character differentiation | 10% | 9/10 |
| Dialogue composition | 10% | 9/10 |
| Native integration | 10% | PASS |
| Target-board coherence | 5% | 9/10 |

Overall approval threshold: **9.0/10** with no hard-gate failure.

---

## 7. Command-to-proof receipt

Character detail is approved only when the receipt can truthfully state:

```json
{
  "character_architecture": "PASS",
  "papa_wook_native": "PASS",
  "papa_wook_four_direction": "PASS",
  "papa_wook_portraits": "PASS",
  "jessica_native": "PASS",
  "jessica_portraits": "PASS",
  "raccoon_native": "PASS",
  "raccoon_encounter": "PASS",
  "dialogue_layout": "PASS",
  "native_web": "PASS",
  "native_rom": "PASS",
  "visual_score": ">=9.0",
  "result": "WOOK_CHARACTER_LEVEL10_PASS"
}
```

No asset-presence-only receipt is accepted.
