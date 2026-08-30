# WOOK-C0-SIDE-QUEST-001 — THE MISSING PASHMINA

Campaign: `WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001`
Chapter: `C00 — WHERE ARE MY SHOES?`
Primary gate: `SIDE_QUEST`

## Mission

Instantiate one complete cartridge-native side quest inside The Questionable Campground and prove the full WOOK side-quest grammar before that grammar is propagated into later chapters.

## Quest

**SQ-C00-001 — THE MISSING PASHMINA**

Quest giver: **Pashmina Pam**
Objective: locate Pam's missing pashmina near the outer edge of camp and return it.

## Required loop

```text
DISCOVER PAM
    ↓
QUEST OFFER
    ↓
ACCEPT / DECLINE
    ↓
QUEST STATE = ACCEPTED
    ↓
WORLD OBJECT BECOMES ACTIONABLE
    ↓
FIND PASHMINA
    ↓
INVENTORY FLAG = POSSESSED
    ↓
RETURN TO PAM
    ↓
STATE VALIDATION
    ↓
ITEM REMOVED
    ↓
QUEST COMPLETE
    ↓
RESPONSIBILITY +1
WOOK KARMA +1
    ↓
REPEAT DIALOGUE CHANGES
```

## Persistent state

- `101` — C0 Pashmina Quest State: 0=not started, 1=accepted, 2=found, 3=complete.
- `102` — C0 Pashmina Menu Choice.
- `103` — C0 Pashmina Possessed: 0/1.

## Acceptance

- quest can be declined without blocking C00;
- quest can later be accepted after declining;
- the pashmina cannot be legitimately collected before the quest is accepted;
- pickup changes persistent state exactly once;
- return removes the possession flag;
- completion rewards Responsibility and Wook Karma exactly once;
- repeat conversations do not duplicate rewards;
- quest state survives the native project build;
- native web compiles;
- ROM compiles;
- receipt result is `WOOK_C0_SIDE_QUEST_NATIVE_PASS`.

## Readiness truth

Compilation proves native validity, not final play quality. Native playtest, save/reload and presentation qualification remain later C00 gates.