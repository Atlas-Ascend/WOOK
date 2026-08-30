# WOOK Character Production System

This directory is the canonical architecture for character identity, fidelity, animation, portrait work, and native GB Studio integration.

## Documents

- `CHARACTER-DETAIL-ARCHITECTURE.md` — system architecture and production tiers
- `CHARACTER-ASSET-CONTRACT.yaml` — machine-readable asset and proof contract
- `PAPA-WOOK-PRODUCTION-BIBLE.md` — original Papa Wook identity / animation baseline
- `CAST-BIBLE.md` — cast identity baseline
- `../production/GB-STUDIO-CHARACTER-INTEGRATION.md` — native resource-graph implementation
- `../qa/CHARACTER-LEVEL10-ACCEPTANCE.md` — Level-10 proof gates

## Active implementation packet

`WOOK-CHAR-GOLDEN-001`

```text
Papa Wook player binding
        ↓
4-direction locomotion
        ↓
Moonbeam Jessica actor + portraits
        ↓
Raccoon actor + encounter
        ↓
Authored dialogue pagination
        ↓
Native web + ROM
        ↓
Visual contract review
```

## Frozen infrastructure

Character work does not recreate:
- Termux environment
- Ubuntu
- Node
- GBDK
- GB Studio CLI
- GB Studio 4.x project migration
- native build pipeline
- GitHub/GitHack publication pipeline

Those lanes are already proven. Character work patches the existing native project in place.
