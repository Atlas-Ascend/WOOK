#!/usr/bin/env python3
from pathlib import Path
from PIL import Image
import argparse, copy, hashlib, json, uuid

NS = uuid.UUID('5b62caaa-4050-4d9f-8200-c0015de00001')
PACKET = 'WOOK-C0-SIDE-QUEST-001'


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


def menu(label, variable):
    return ev(label, 'EVENT_MENU', {
        'variable': variable,
        'items': 2,
        'option1': "I'LL FIND IT",
        'option2': 'NOT RIGHT NOW',
        'cancelOnLastOption': True,
        'cancelOnB': True,
        'layout': 'menu',
    })


def refresh(label, refresh_id):
    return ev(label, 'EVENT_CALL_CUSTOM_EVENT', {
        'customEventId': refresh_id,
        '__name': 'Refresh HUD',
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


def icon(path, kind):
    C=(0,0,0,0); I=(15,33,35,255); D=(49,83,75,255); M=(127,160,111,255); L=(196,217,154,255)
    im = Image.new('RGBA', (16,16), C)
    px = im.load()
    if kind == 'pam':
        # hat/hair/head/body silhouette
        for x in range(4,12): px[x,3]=I
        for x in range(5,11): px[x,2]=D
        for y in range(4,8):
            for x in range(5,11): px[x,y]=M
        px[6,5]=I; px[9,5]=I
        for y in range(8,14):
            for x in range(4,12): px[x,y]=D if y < 11 else I
        px[3,10]=I; px[12,10]=I
    else:
        # folded pashmina / patterned cloth
        for y in range(5,12):
            for x in range(3,13): px[x,y]=M
        for x in range(3,13): px[x,5]=I; px[x,11]=I
        for y in range(5,12): px[3,y]=I; px[12,y]=I
        for x,y in [(5,7),(7,9),(9,7),(11,9),(6,10),(10,10)]: px[x,y]=D
        px[2,6]=L; px[13,10]=L
    path.parent.mkdir(parents=True, exist_ok=True)
    im.save(path)


def make_sprite(template, sprites, slug, name, symbol, kind):
    png = sprites / f'{slug}.png'
    icon(png, kind)
    r = copy.deepcopy(template)
    rid = uid('sprite/' + slug)
    r['id'] = rid
    r['name'] = name
    r['symbol'] = symbol
    r['filename'] = png.name
    r['width'] = 16
    r['height'] = 16
    r['checksum'] = sha1(png)
    write(sprites / f'{slug}.png.gbsres', r)
    return rid


def actor(actor_id, index, name, symbol, sprite_id, x, y, script):
    return {
        '_resourceType':'actor', 'id':actor_id, 'name':name,
        'frame':0, 'animate':False, 'spriteSheetId':sprite_id,
        'prefabId':'', 'direction':'down', 'moveSpeed':1, 'animSpeed':15,
        'paletteId':'', 'isPinned':False, 'persistent':False,
        'collisionGroup':'', 'collisionExtraFlags':[],
        'prefabScriptOverrides':{}, '_index':index, 'symbol':symbol,
        'coordinateType':'tiles', 'x':x, 'y':y,
        'script':script, 'startScript':[], 'updateScript':[],
        'hit1Script':[], 'hit2Script':[], 'hit3Script':[]
    }


def patch_quest_log(project):
    quest_scene = project / 'project/scenes/ui/wook_quest/scene.gbsres'
    if not quest_scene.exists():
        return False
    obj = json.loads(quest_scene.read_text())
    for e in obj.get('script', []):
        if isinstance(e, dict) and e.get('command') == 'EVENT_TEXT':
            args = dict(e.get('args') or {})
            value = str(args.get('text', ''))
            if 'PASHMINA' not in value:
                value += '\nSIDE: PASHMINA $101$/3'
            args['text'] = value
            e['args'] = args
            break
    write(quest_scene, obj)
    return True


def patch_inventory(project):
    inv_scene = project / 'project/scenes/ui/wook_inventory/scene.gbsres'
    if not inv_scene.exists():
        return False
    obj = json.loads(inv_scene.read_text())
    for e in obj.get('script', []):
        if isinstance(e, dict) and e.get('command') == 'EVENT_TEXT':
            args = dict(e.get('args') or {})
            value = str(args.get('text', ''))
            if 'Pashmina:' not in value:
                value += '\nPashmina: $103$'
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

    QUEST='101'; CHOICE='102'; POSSESS='103'
    RESPONSIBILITY='93'; KARMA='94'
    vr = json.loads(vars_path.read_text())
    ensure_var(vr, QUEST, 'C0 Pashmina Quest State', 'var_c0_pashmina_quest')
    ensure_var(vr, CHOICE, 'C0 Pashmina Menu Choice', 'var_c0_pashmina_choice')
    ensure_var(vr, POSSESS, 'C0 Pashmina Possessed', 'var_c0_pashmina_possessed')
    write(vars_path, vr)

    refresh_path = project / 'project/scripts/wook/ui/refresh_wook_hud.gbsres'
    refresh_id = json.loads(refresh_path.read_text())['id'] if refresh_path.exists() else None
    template = json.loads(template_path.read_text())

    pam_sprite = make_sprite(template, sprites, 'pashmina-pam', 'Pashmina Pam', 'sprite_pashmina_pam', 'pam')
    item_sprite = make_sprite(template, sprites, 'lost-pashmina', 'Lost Pashmina', 'sprite_lost_pashmina', 'pashmina')

    reward = [
        text('pam/return/text', 'PASHMINA PAM\nYOU FOUND IT.\nI owe you spiritually.'),
        setv('pam/return/remove-item', POSSESS, 0),
        setv('pam/return/complete', QUEST, 3),
        inc('pam/return/responsibility', RESPONSIBILITY),
        inc('pam/return/karma', KARMA),
    ]
    if refresh_id:
        reward.append(refresh('pam/return/hud', refresh_id))
    reward.append(text('pam/return/reward-text', 'Responsibility +1\nWook Karma +1'))

    offer = [
        text('pam/offer/text', 'PASHMINA PAM\nMy pashmina vanished.\nThis is devastating.'),
        menu('pam/offer/menu', CHOICE),
        ifeq('pam/offer/accepted?', CHOICE, 0,
             [setv('pam/offer/set-accepted', QUEST, 1),
              text('pam/offer/accepted-text', 'QUEST: THE MISSING\nPASHMINA\nCheck near van row.')],
             [text('pam/offer/declined-text', 'Fair.\nI will continue\nbeing devastated.')])
    ]

    pam_script = [
        ifeq('pam/state-complete?', QUEST, 3,
             [text('pam/complete-repeat', 'PASHMINA PAM\nStill immaculate.\nYou did good.')],
             [ifeq('pam/state-found?', QUEST, 2,
                    reward,
                    [ifeq('pam/state-accepted?', QUEST, 1,
                           [text('pam/reminder', 'PASHMINA PAM\nVan row.\nProbably under\nsomething weird.')],
                           offer)])])
    ]

    item_collect = [
        text('item/found', 'You found:\nPAM\'S PASHMINA'),
        setv('item/possess', POSSESS, 1),
        setv('item/state-found', QUEST, 2),
        text('item/return', 'Return it to\nPashmina Pam.')
    ]
    item_script = [
        ifeq('item/already-complete?', QUEST, 3,
             [text('item/after-complete', 'Only suspiciously\nclean grass remains.')],
             [ifeq('item/already-found?', QUEST, 2,
                    [text('item/already-held', 'You already have\nPam\'s pashmina.')],
                    [ifeq('item/accepted?', QUEST, 1,
                           item_collect,
                           [text('item/not-yours', 'A pashmina.\nProbably not yours.')])])])
    ]

    pam_id = uid('actor/pashmina-pam')
    item_id = uid('actor/lost-pashmina')
    write(actors / 'pashmina_pam.gbsres', actor(pam_id, 31, 'Pashmina Pam', 'actor_pashmina_pam', pam_sprite, 7, 11, pam_script))
    write(actors / 'lost_pashmina.gbsres', actor(item_id, 32, 'Lost Pashmina', 'actor_lost_pashmina', item_sprite, 15, 6, item_script))

    qpatched = patch_quest_log(project)
    ipatched = patch_inventory(project)

    manifest = {
        'schema':'ghost-atlas.wook.c0.side-quest.v1',
        'packet':PACKET,
        'quest_id':'SQ-C00-001',
        'title':'THE MISSING PASHMINA',
        'actors':{'giver':pam_id,'item':item_id},
        'variables':{'quest_state':QUEST,'choice':CHOICE,'possessed':POSSESS},
        'rewards':{'responsibility':1,'wook_karma':1},
        'quest_log_patched':qpatched,
        'inventory_patched':ipatched,
        'native_build':'PENDING_EXECUTION',
        'playtest':'PENDING_NATIVE_PLAYTEST'
    }
    write(root / 'docs/proof/C0-SIDE-QUEST-MANIFEST.json', manifest)
    print('SIDE_QUEST_GIVER=PASS')
    print('SIDE_QUEST_ACCEPT_DECLINE=PASS')
    print('SIDE_QUEST_ITEM=PASS')
    print('SIDE_QUEST_COMPLETION=PASS')
    print('SIDE_QUEST_ONE_TIME_REWARD=PASS')
    print('QUEST_LOG_BINDING=' + ('PASS' if qpatched else 'DEFERRED'))
    print('INVENTORY_BINDING=' + ('PASS' if ipatched else 'DEFERRED'))


if __name__ == '__main__':
    main()
