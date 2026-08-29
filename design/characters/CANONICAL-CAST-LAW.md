# WOOK Canonical Cast Law

## Active named cast

```text
Papa Wook
Train Station
Loki
The Wizard
Bufo D' Clown
Handstand Dan
Sniffany
```

This list is the active named roster for WOOK V4 — Cartridge Class.

Additional characters may be named only by deliberate canon promotion.

## Forward-production rule

New game content MUST use canonical production identities:

```text
papa_wook
train_station
loki
the_wizard
bufo_d_clown
handstand_dan
sniffany
```

Creature and functional role names such as `raccoon`, `security_01`, `vendor_02`, and `camper_03` are allowed without becoming named cast members.

## Deprecated placeholders

Earlier development placeholders are retired from active canon. They may remain in historical commits, archived receipts, or clearly labeled migration notes, but are forbidden in new runtime resources, dialogue, quests, UI, save-state keys, and current narrative content.

No automatic identity mapping from a retired placeholder to a canonical character is presumed.

## Naming philosophy

WOOK does not fill the world with disposable comedy names. If someone is important enough to be named, the name must carry memory, performance, story function, or lived culture.

## Enforcement

Run:

```bash
bash scripts/audit-canonical-cast.sh
```

The audit scans the active native project and current act/quest material for retired placeholder identities.

**Status:** FROZEN.