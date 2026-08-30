# WOOK-C0-GA-EXIT-001 — LEAVE THE QUESTIONABLE CAMPGROUND

Campaign: `WOOK-ENCYCLOPEDIA-COMMAND-TO-PROOF-001`
Chapter: `C00 — WHERE ARE MY SHOES?`
Primary gate: `GA_EXIT`
Downstream chapter: `C01 — GENERAL ADMISSION`

## Mission

Create the first real chapter-boundary trigger. C00 may release Papa Wook from The Questionable Campground only after the critical Crocs requirement is satisfied.

## Gate

Trigger sits on the campground edge and evaluates the C00 Crocs display/state count.

```text
CROCS < 2
  → block transition
  → authored feedback

CROCS == 2
  → transition to GA Main Lane entry seam
```

Blocked feedback:

```text
Absolutely not.
You are not leaving
camp barefoot.
```

## Target scene

`GA Main Lane — C01 Entry Seam`

This scene is deliberately an **entry seam**, not a claim that C01 is complete. It exists so C00 can prove a valid exit and C01 has a stable native scene identity/spawn contract to build outward from.

## Acceptance

- campground trigger exists;
- transition is gated by Crocs completion;
- blocked state gives nonfatal feedback;
- target scene resource exists;
- target background exists;
- target spawn is valid;
- native web compiles;
- ROM compiles;
- packet receipt result is `WOOK_C0_GA_EXIT_NATIVE_PASS`;
- C01 remains `PENDING` until its own chapter receipt proves it.