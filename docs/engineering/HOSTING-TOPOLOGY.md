# Hosting Topology

## GitHub
Canonical source, commit lineage, proof receipts.

## GitHack
Immediate static mirror / development accessibility.

## Vercel
Polished production CDN/deployment lane.

## Cloudflare Workers Static Assets
Independent edge lane and future custom-domain/security surface.

## Public routing law
`site/index.html` is a boot router:
1. prefer `site/gbstudio/index.html` if native GB Studio web export exists,
2. otherwise fall back to `site/golden/index.html`.

The fallback is visual QA and continuity; it is not accepted as native GB Studio proof.
