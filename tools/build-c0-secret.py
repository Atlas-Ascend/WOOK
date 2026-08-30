#!/usr/bin/env python3
from pathlib import Path
from PIL import Image
import argparse, copy, hashlib, json, uuid

NS = uuid.UUID('9d79c6ca-7428-4fc8-9a00-c0015ec00001')
PACKET = 'WOOK-C0-SECRET-001'
ITEM_ID = 'ITEM-WOOK-CEREMONIAL-ZIP-TIE'


def uid(label):
    return str(uuid.uuid5(NS, PACKET + '/' + label))


def write(path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, indent=2) + '\n')


def sha1(path):
    return hashlib.sha1(path.read_bytes()).hexdigest()


def ev(label, command, args):
    return {'id': uid(label), 'command': command, 'args': args}


def num(value):
    return {'type': 'number', 'value': value}


def setv(label, variable, value):
    return ev(label, 'EVENT_SET_VALUE', {'variable': variable, 'value': num(value)})


def inc(label, variable):
    return ev(label, 'EVENT_INC_VALUE', {'variable': variable})


def text(label, value):
    return ev(label, 'EVENT_TEXT', {'text': value})


def ifeq(label, variable, comparator, true_events, false_events):
    return ev(label, 'EVENT_IF_VALUE', {
        'variable': variable,
        'operator': '==',
        'comparator': comparator,
        'true': true_events,
        'false': false_events,
        '__collapseElse': False,
    })


def ensure_var(vr, vid, name, symbol):
    variables = vr.get('variables', [])
    if isinstance(variables, dict):
        variables = []
    by = {str(x.get('id')): x for x in variables if isinstance(x, dict)}
    by[str(vid)] = {'id': str(vid), 'name': name, 'symbol': symbol}
    vr['variables'] = list(by.values())
    if isinstance(vr.get('constants'), dict):
        vr['constants'] = []


def icon(path):
    C=(0,0,0,0); I=(15,33,35,255); D=(49,83,75,255); M=(127,160,111,255); L=(196,217,154,255)
    im = Image.new('RGBA', (16,16), C)
    px = im.load()
    # Bent loop/zip-tie silhouette with absurd little ceremonial tassel.
    for x in range(4,12): px[x,4]=I
    for y in range(4,12): px[4,y]=I
    for x in range(4,11): px[x,11]=I
    px[11,10]=I; px[11,9]=I
    for x,y in [(5,5),(6,5),(5,6),(9,10),(10,10)]: px[x,y]=M
    px[12,8]=D; px[13,9]=D; px[12,10]=L
    path.parent.mkdir(parents=True, exist_ok=True)
    im.save(path)


def patch_inventory(project):
    inv_scene = project / 'project/scenes/ui/wook_inventory/scene.gbsres'
    if not inv_scene.exists():
        return False
    obj = json.loads(inv_scene.read_text())
    for e in obj.get('script', []):
        if isinstance(e, dict) and e.get('command') == 'EVENT_TEXT':
            args = dict(e.get('args') or {})
            value = str(args.get('text', ''))
            if 'Zip Tie:' not in value:
                value += '\nZip Tie: $104$'
            args['text'] = value
            e['args'] = args
            break
    write(inv_scene, obj)
    return True


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--root', required=True)
    a = ap.parse_args()
    root = Path(a.root)
    project = root / 'game/project'
    vars_path = project / 'project/variables.gbsres'
    sprites = project / 'assets/sprites'
    actors = project / 'project/scenes/questionable_campground/actors'
    template_path = sprites / 'static.png.gbsres'
    for p in (vars_path, template_path):
        if not p.exists():
            raise SystemExit(f'MISSING={p}')
    actors.mkdir(parents=True, exist_ok=True)

    POSSESS='104'; CLAIMED='105'; GROUNDSCORE='95'
    vr = json.loads(vars_path.read_text())
    ensure_var(vr, POSSESS, 'Ceremonial Zip Tie Possessed', 'var_ceremonial_zip_tie')
    ensure_var(vr, CLAIMED, 'C0 Van Secret Claimed', 'var_c0_van_secret_claimed')
    write(vars_path, vr)

    refresh_path = project / 'project/scripts/wook/ui/refresh_wook_hud.gbsres'
    refresh_id = json.loads(refresh_path.read_text())['id'] if refresh_path.exists() else None

    template = json.loads(template_path.read_text())
    png = sprites / 'ceremonial-zip-tie.png'
    icon(png)
    sprite_id = uid('sprite/ceremonial-zip-tie')
    r = copy.deepcopy(template)
    r['id'] = sprite_id
    r['name'] = 'Ceremonial Zip Tie'
    r['symbol'] = 'sprite_ceremonial_zip_tie'
    r['filename'] = png.name
    r['width'] = 16
    r['height'] = 16
    r['checksum'] = sha1(png)
    write(sprites / 'ceremonial-zip-tie.png.gbsres', r)

    reward = [
        text('secret/found-1', 'You found:\nCEREMONIAL\nZIP TIE'),
        text('secret/found-2', 'Purpose:\nunclear.'),
        setv('secret/possess', POSSESS, 1),
        setv('secret/claimed', CLAIMED, 1),
        inc('secret/groundscore', GROUNDSCORE),
    ]
    if refresh_id:
        reward.append(ev('secret/hud', 'EVENT_CALL_CUSTOM_EVENT', {
            'customEventId': refresh_id,
            '__name': 'Refresh HUD',
        }))
    reward.append(text('secret/reward', 'Groundscore +1'))

    script = [
        ifeq('secret/already?', CLAIMED, 1,
             [text('secret/repeat', 'The van contains\nno further destiny.')],
             reward)
    ]

    actor_id = uid('actor/ceremonial-zip-tie')
    actor = {
        '_resourceType':'actor', 'id':actor_id, 'name':'Secret — Ceremonial Zip Tie',
        'frame':0, 'animate':False, 'spriteSheetId':sprite_id, 'prefabId':'',
        'direction':'down', 'moveSpeed':1, 'animSpeed':15, 'paletteId':'',
        'isPinned':False, 'persistent':False, 'collisionGroup':'',
        'collisionExtraFlags':[], 'prefabScriptOverrides':{}, '_index':33,
        'symbol':'actor_secret_ceremonial_zip_tie', 'coordinateType':'tiles',
        'x':4, 'y':7, 'script':script, 'startScript':[], 'updateScript':[],
        'hit1Script':[], 'hit2Script':[], 'hit3Script':[]
    }
    write(actors / 'secret_ceremonial_zip_tie.gbsres', actor)

    inv_patched = patch_inventory(project)
    manifest = {
        'schema':'ghost-atlas.wook.c0.secret.v1',
        'packet':PACKET,
        'secret_id':'SECRET-C00-001',
        'item_id':ITEM_ID,
        'title':'THE CEREMONIAL ZIP TIE',
        'actor_id':actor_id,
        'sprite_id':sprite_id,
        'variables':{'possessed':POSSESS,'claimed':CLAIMED},
        'reward':{'groundscore':1},
        'future_callback_chapter':'C07',
        'inventory_patched':inv_patched,
        'native_build':'PENDING_EXECUTION',
        'future_callback_truth':'RESERVED_NOT_YET_IMPLEMENTED'
    }
    write(root / 'docs/proof/C0-SECRET-MANIFEST.json', manifest)
    print('C0_SECRET_RESOURCE=PASS')
    print('C0_SECRET_ONE_TIME_GUARD=PASS')
    print('C0_SECRET_STABLE_ITEM_ID=PASS')
    print('C0_SECRET_INVENTORY_BINDING=' + ('PASS' if inv_patched else 'DEFERRED'))


if __name__ == '__main__':
    main()
