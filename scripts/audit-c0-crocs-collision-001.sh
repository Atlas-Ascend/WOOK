#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel)"
PROJECT="$ROOT/game/project"
SCENE="$PROJECT/project/scenes/questionable_campground/scene.gbsres"
VARS="$PROJECT/project/variables.gbsres"
ACTORS="$PROJECT/project/scenes/questionable_campground/actors"
MANIFEST="$ROOT/docs/proof/C0-CROCS-COLLISION-MANIFEST.json"

for f in "$SCENE" "$VARS" "$ACTORS/croc_left.gbsres" "$ACTORS/croc_right.gbsres" "$MANIFEST"; do
  test -s "$f" || { echo "MISSING=$f"; exit 10; }
done

python - "$ROOT" <<'PY'
from pathlib import Path
from collections import deque
import json,sys
root=Path(sys.argv[1]); project=root/'game/project'; scene=json.loads((project/'project/scenes/questionable_campground/scene.gbsres').read_text()); vars=json.loads((project/'project/variables.gbsres').read_text()); topo=json.loads((root/'design/gameplay/C0-CAMPGROUND-TOPOLOGY.json').read_text()); manifest=json.loads((root/'docs/proof/C0-CROCS-COLLISION-MANIFEST.json').read_text())
assert scene['collisions'], 'collision string empty'
assert isinstance(vars['variables'],list), 'variables schema is not array'
required={'VAR_LEFT','VAR_RIGHT','VAR_COUNT','VAR_RACCOON','VAR_VENUE','VAR_COMPLETE'}
assert required <= {v['symbol'] for v in vars['variables']}, 'missing C0 state vars'
def decompress(s):
    a=[]; i=0
    while i<len(s):
        v=int(s[i:i+2],16); i+=2
        if s[i]=='!': n=1; i+=1
        else:
            j=s.index('+',i); n=int(s[i:j],16); i=j+1
        a += [v]*n
    return a
grid=decompress(scene['collisions']); w,h=topo['width'],topo['height']; assert len(grid)==w*h
nodes={k:tuple(v) for k,v in topo['nodes'].items()}
def route(a,b):
    q=deque([a]); seen={a}
    while q:
        x,y=q.popleft()
        if (x,y)==b:return True
        for p in ((x+1,y),(x-1,y),(x,y+1),(x,y-1)):
            nx,ny=p
            if 0<=nx<w and 0<=ny<h and grid[ny*w+nx]==0 and p not in seen: seen.add(p); q.append(p)
    return False
for a,b in topo['required_routes']: assert route(nodes[a],nodes[b]), f'route blocked {a}->{b}'
for name in ('croc_left','croc_right'):
    a=json.loads((project/f'project/scenes/questionable_campground/actors/{name}.gbsres').read_text())
    assert a['persistent'] is False
    assert a['script'], name+' has no script'
assert manifest['route_audit']=='PASS'
print('C0_COLLISION_DECOMPRESS=PASS')
print('C0_ROUTE_COVERAGE=PASS')
print('C0_CROCS_STATE_GRAPH=PASS')
PY

echo "WOOK_C0_CROCS_COLLISION_STATIC_AUDIT=PASS"
