# WOOK-C0-STATE-MUTATIONS-001

## Mission

Turn the C0 social stats from architecture into native, observable gameplay mutations.

This packet owns:

- `GROUNDSCORE`
- `RESPONSIBILITY`
- `WOOK_KARMA`

It adds three one-time campground interactions and proves that each mutation is deterministic, non-repeatable, HUD/menu-compatible, and native-ROM compilable.

## Interaction A — Groundscore Cache

Behind/near the van, Papa discovers a strange but potentially useful object.

First interaction:

```text
You found:
MYSTERY CARABINER
Groundscore +1
```

State:

```text
Groundscore += 1
C0_GROUNDSCORE_CACHE_CLAIMED = 1
```

Repeated interaction must not duplicate the reward.

## Interaction B — Community Water

Papa handles a small practical camp task instead of walking past it.

First interaction:

```text
You refill the camp water.
Responsibility +1
```

State:

```text
Responsibility += 1
C0_WATER_TASK_DONE = 1
```

This is the first explicit mechanical demonstration that Responsibility represents competence/follow-through, not morality.

## Interaction C — Lost Cup Return

Papa returns a labeled cup to the camp return spot.

First interaction:

```text
Cup returned.
Wook Karma +1
```

State:

```text
Wook Karma += 1
C0_CUP_RETURNED = 1
```

This establishes reciprocal-community state without a good/evil meter.

## Variable contract

Presentation variables already established by the HUD packet:

- `93` Responsibility
- `94` Wook Karma
- `95` Groundscore

One-time flags:

- `98` Groundscore Cache Claimed
- `99` Water Task Done
- `100` Cup Returned

## Native resources

The packet creates deterministic prop sprites and actor resources in The Questionable Campground, patches the HUD refresh custom event after each first-time mutation when available, compiles native web + ROM, and writes:

`docs/proof/receipts/C0-STATE-MUTATIONS-LATEST.json`

Result:

`WOOK_C0_STATE_MUTATIONS_NATIVE_PASS`

This packet does not claim the full C0 side-quest gate; it proves the three core stat mutations only.
