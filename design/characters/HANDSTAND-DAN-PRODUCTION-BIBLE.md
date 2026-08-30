# Handstand Dan — Production Bible

**Packet:** `WOOK-C0-HANDSTAND-DAN-001`  
**Tier:** B — Principal recurring ally  
**Primary map:** The Questionable Campground  
**Primary function:** physical-comedy ally, challenge/minigame specialist, recurring competence mirror.

## Character thesis

Handstand Dan is funny before he speaks because he is frequently upside down at moments when everyone else is trying to solve something normally.

He must not read as a generic festival NPC with a renamed dialogue box. His silhouette, animation and interaction grammar must identify him instantly.

## Visual anchors

- narrow/lanky body mass;
- headband or tied hair cue;
- long arm readability;
- wrist-wrap cue;
- compact shorts / practical lower-body silhouette;
- highly readable inverted handstand pose;
- upright idle that still feels spring-loaded;
- no silhouette reuse from Papa Wook or Sniffany.

## Native animation family

Required minimum:

```text
idle_down
idle_side
walk_down
walk_side
handstand_enter
handstand_hold
handstand_wobble
handstand_recover
challenge_success
challenge_fail
```

The first native integration may use a compact six-frame sprite sheet, but the production contract retains the complete family above and upgrades may not churn the stable character/resource identity.

## Portrait family

- neutral;
- upside_down;
- focused;
- delighted;
- concerned;
- challenge_mode.

## C0 interaction

First interaction establishes his comic rhythm:

```text
HANDSTAND DAN
Can you hold this?

PAPA WOOK
You're upside down.

HANDSTAND DAN
That wasn't the question.
```

His first challenge remains optional and cannot block the Crocs critical path.

## Mechanical arc

C0: teaches optional challenge grammar.  
C3: performance/venue challenge callback.  
C4: impossible night challenge.  
C7: physical competence may support an Ordeal route.  
C9+: recurring challenge chains can resolve into social/cosmetic rewards rather than power scaling.

## State contract

```text
handstand_dan:
  met
  first_challenge_seen
  first_challenge_complete
  affinity
  chapter_variant
  current_map
```

## Acceptance

```text
DISTINCT_SILHOUETTE=PASS
NATIVE_SPRITE_RESOURCE=PASS
NATIVE_ACTOR_RESOURCE=PASS
PORTRAIT_RESOURCE=PASS
OPTIONAL_INTERACTION=PASS
CRITICAL_PATH_NONBLOCKING=PASS
NATIVE_WEB_RENDER=PASS
ROM_BUILD=PASS
VISUAL_QA>=9
```

Compiler success does not constitute final visual qualification.
