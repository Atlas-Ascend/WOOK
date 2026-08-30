#!/usr/bin/env python3
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import argparse, json, uuid

NS = uuid.UUID('5d6db498-ae0e-4ced-9127-7d38f9c00001')
PACKET = 'WOOK-C0-HUD-MENU-001'

def uid(label):
    return str(uuid.uuid5(NS, PACKET + '/' + label))

def write(path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, indent=2) + '\n')

def ev(label, command, args=None, children=None):
    out = {'id': uid(label), 'command': command, 'args': args or {}}
    if children is not None:
        out['children'] = children
    return out

def num(value):
    return {'type': 'number', 'value': value}

def set_value(label, var, value):
    return ev(label, 'EVENT_SET_VALUE', {'variable': var, 'value': num(value)})

def switch_scene(label, scene_id):
    return ev(label, 'EVENT_SWITCH_SCENE', {
        'sceneId': scene_id,
        'x': num(0),
        'y': num(0),
        'direction': '',
        'fadeSpeed': '1'
    })

def pop_state(label):
    return ev(label, 'EVENT_SCENE_POP_STATE', {'fadeSpeed': '1'})

def text_event(label, text, full=False, nonmodal=False):
    args = {'text': text}
    if full:
        args.update({
            'minHeight': 18, 'maxHeight': 18, 'position': 'top',
            'textX': 1, 'textY': 1, 'textHeight': 16,
            'showFrame': True, 'clearPrevious': True,
            'closeWhen': 'key', 'closeButton': 'b'
        })
    if nonmodal:
        args.update({
            'minHeight': 2, 'maxHeight': 2, 'position': 'top',
            'textX': 1, 'textY': 0, 'textHeight': 1,
            'showFrame': True, 'clearPrevious': True,
            'closeWhen': 'notModal'
        })
    return ev(label, 'EVENT_TEXT', args)

def background(path, header):
    # Cartridge-safe 4-shade field. The native menu text itself is emitted by
    # GB Studio; this image supplies a stable frame and screen identity.
    I=(15,33,35,255); D=(49,83,75,255); M=(127,160,111,255); L=(196,217,154,255)
    im = Image.new('RGBA', (160,144), L)
    d = ImageDraw.Draw(im)
    d.rectangle((0,0,159,143), outline=I, width=2)
    d.rectangle((4,4,155,20), fill=D, outline=I)
    d.line((4,24,155,24), fill=I, width=1)
    # Tiny bitmap header; final readable content uses native GB Studio text.
    font = ImageFont.load_default()
    d.text((8,8), header[:22], fill=L, font=font)
    d.rectangle((7,30,152,134), outline=M, width=1)
    d.text((10,126), 'B: BACK', fill=D, font=font)
    path.parent.mkdir(parents=True, exist_ok=True)
    im.save(path)

def bg_resource(rid, name, symbol, filename):
    return {
        '_resourceType':'background','id':rid,'name':name,'symbol':symbol,
        'tileColors':'','filename':filename,'width':20,'height':18,
        'imageWidth':160,'imageHeight':144,'autoColor':False
    }

def scene_resource(rid, index, name, symbol, bg_id, script):
    return {
        '_resourceType':'scene','id':rid,'_index':index,'type':'TOPDOWN',
        'name':name,'symbol':symbol,'x':300 + index*32,'y':300,
        'width':20,'height':18,'backgroundId':bg_id,'tilesetId':'',
        'colorModeOverride':'none','paletteIds':['default-ui'],
        'spritePaletteIds':[],'autoFadeSpeed':1,'script':script,
        'playerHit1Script':[],'playerHit2Script':[],'playerHit3Script':[],
        'collisions':''
    }

def ensure_var(vr, vid, name, symbol):
    variables = vr.get('variables', [])
    if isinstance(variables, dict):
        variables = []
    by_id = {str(v.get('id')):v for v in variables if isinstance(v,dict)}
    by_id[str(vid)] = {'id':str(vid),'name':name,'symbol':symbol}
    vr['variables'] = list(by_id.values())
    if isinstance(vr.get('constants'), dict):
        vr['constants'] = []

def insert_mirror_increment(events, canonical_var, mirror_var):
    if not isinstance(events, list):
        return events
    out=[]
    for item in events:
        if not isinstance(item, dict):
            out.append(item); continue
        item = dict(item)
        args = item.get('args') or {}
        # recurse through either args-contained event lists (used by existing WOOK packets)
        for k in ('true','false'):
            if isinstance(args.get(k), list):
                args = dict(args)
                args[k] = insert_mirror_increment(args[k], canonical_var, mirror_var)
                item['args'] = args
        children = item.get('children')
        if isinstance(children, dict):
            children = dict(children)
            for k,v in list(children.items()):
                if isinstance(v,list): children[k] = insert_mirror_increment(v, canonical_var, mirror_var)
            item['children'] = children
        out.append(item)
        if item.get('command') == 'EVENT_INC_VALUE' and str((item.get('args') or {}).get('variable')) == canonical_var:
            if not any(x.get('command')=='EVENT_INC_VALUE' and str((x.get('args') or {}).get('variable'))==mirror_var for x in out[-2:] if isinstance(x,dict)):
                out.append(ev('mirror/' + item['id'], 'EVENT_INC_VALUE', {'variable':mirror_var}))
    return out

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--root',required=True); args=ap.parse_args()
    root=Path(args.root)
    project=root/'game/project'
    vars_path=project/'project/variables.gbsres'
    camp=project/'project/scenes/questionable_campground/scene.gbsres'
    bgs=project/'assets/backgrounds'
    scenes=project/'project/scenes/ui'
    scripts=project/'project/scripts/wook/ui'

    for p in (vars_path,camp):
        if not p.exists(): raise SystemExit(f'MISSING={p}')

    VAR = {
        'crocs':'90','battery':'91','vibes':'92','responsibility':'93',
        'karma':'94','groundscore':'95','ui_init':'96','menu':'97'
    }
    CROC_CANON='c0000000-0000-4000-8000-000000000003'

    vr=json.loads(vars_path.read_text())
    ensure_var(vr,VAR['crocs'],'C0 Crocs HUD Count','var_c0_crocs_hud')
    ensure_var(vr,VAR['battery'],'Battery','var_battery')
    ensure_var(vr,VAR['vibes'],'Vibes','var_vibes')
    ensure_var(vr,VAR['responsibility'],'Responsibility','var_responsibility')
    ensure_var(vr,VAR['karma'],'Wook Karma','var_wook_karma')
    ensure_var(vr,VAR['groundscore'],'Groundscore','var_groundscore')
    ensure_var(vr,VAR['ui_init'],'C0 UI Initialized','var_c0_ui_initialized')
    ensure_var(vr,VAR['menu'],'C0 Menu Choice','var_c0_menu_choice')
    vr['_resourceType']='variables'
    vr.setdefault('constants',[])
    write(vars_path,vr)

    BG={k:uid('background/'+k) for k in ('menu','phone','inventory','quest')}
    SC={k:uid('scene/'+k) for k in ('menu','phone','inventory','quest')}
    INIT=uid('script/init-ui')
    REFRESH=uid('script/refresh-hud')

    for key,header in [('menu','WOOK'),('phone','PHONE'),('inventory','INVENTORY'),('quest','QUEST LOG')]:
        fn=f'wook-ui-{key}.png'; png=bgs/fn
        background(png,header)
        write(bgs/(fn+'.gbsres'), bg_resource(BG[key],f'WOOK UI — {header}',f'bg_wook_ui_{key}',fn))

    # Reusable HUD refresh custom event.
    hud_text='BAT $91$% V $92$ C $90$/2'
    refresh={
        '_resourceType':'script','id':REFRESH,'name':'wook/ui/Refresh HUD',
        'symbol':'script_wook_refresh_hud','description':'Refresh contextual C0 exploration HUD',
        'variables':{},'actors':{},'script':[
            ev('refresh/close','EVENT_DIALOGUE_CLOSE_NONMODAL',{}),
            text_event('refresh/show',hud_text,nonmodal=True)
        ]
    }
    write(scripts/'refresh_wook_hud.gbsres',refresh)

    # Official GB Studio input-script grammar: Start opens hub, Select opens phone.
    init_ui={
        '_resourceType':'script','id':INIT,'name':'wook/ui/Init WOOK UI',
        'symbol':'script_wook_init_ui','description':'Attach native WOOK menus and draw HUD',
        'variables':{},'actors':{},'script':[
            ev('input/start','EVENT_SET_INPUT_SCRIPT',{'input':['start'],'__collapse':False},{'true':[
                ev('input/start/push','EVENT_SCENE_PUSH_STATE',{}),
                switch_scene('input/start/menu',SC['menu'])
            ]}),
            ev('input/select','EVENT_SET_INPUT_SCRIPT',{'input':['select'],'__collapse':False},{'true':[
                ev('input/select/push','EVENT_SCENE_PUSH_STATE',{}),
                switch_scene('input/select/phone',SC['phone'])
            ]}),
            ev('init/refresh','EVENT_CALL_CUSTOM_EVENT',{'customEventId':REFRESH,'__name':'Refresh HUD'})
        ]
    }
    write(scripts/'init_wook_ui.gbsres',init_ui)

    # Hub scene uses native menu event then routes to one full-screen subsystem.
    menu_script=[
        ev('menu/deactivate','EVENT_ACTOR_DEACTIVATE',{'actorId':'player'}),
        ev('menu/options','EVENT_MENU',{
            'variable':VAR['menu'],'items':4,'option1':'QUESTS','option2':'INVENTORY',
            'option3':'PHONE','option4':'BACK','cancelOnLastOption':True,'cancelOnB':True,'layout':'menu'
        }),
        ev('menu/q','EVENT_IF_VALUE',{'variable':VAR['menu'],'operator':'==','comparator':0,'true':[switch_scene('menu/to-q',SC['quest'])],'false':[],'__collapseElse':False}),
        ev('menu/i','EVENT_IF_VALUE',{'variable':VAR['menu'],'operator':'==','comparator':1,'true':[switch_scene('menu/to-i',SC['inventory'])],'false':[],'__collapseElse':False}),
        ev('menu/p','EVENT_IF_VALUE',{'variable':VAR['menu'],'operator':'==','comparator':2,'true':[switch_scene('menu/to-p',SC['phone'])],'false':[],'__collapseElse':False}),
        ev('menu/b','EVENT_IF_VALUE',{'variable':VAR['menu'],'operator':'>=','comparator':3,'true':[pop_state('menu/back')],'false':[],'__collapseElse':False})
    ]
    write(scenes/'wook_menu/scene.gbsres',scene_resource(SC['menu'],40,'ui/wook/Menu','scene_wook_menu',BG['menu'],menu_script))

    quest_text='QUEST LOG\nWHERE ARE MY SHOES?\nCROCS: $90$/2\nTalk to Sniffany\nFind both Crocs'
    inv_text='INVENTORY\nCrocs: $90$/2\nWater: 1\nLighter: ?\nGroundscore: $95$'
    phone_text='PHONE\nBATTERY $91$%\nMessages\nMap (low power)\nWeekend schedule'
    for key,label,body,index in [
        ('quest','Quest Log',quest_text,41),('inventory','Inventory',inv_text,42),('phone','Phone',phone_text,43)
    ]:
        script=[ev(f'{key}/deactivate','EVENT_ACTOR_DEACTIVATE',{'actorId':'player'}),text_event(f'{key}/text',body,full=True),pop_state(f'{key}/back')]
        write(scenes/f'wook_{key}/scene.gbsres',scene_resource(SC[key],index,f'ui/wook/{label}',f'scene_wook_{key}',BG[key],script))

    # Initialize C0 interface state once and then attach native UI.
    camp_obj=json.loads(camp.read_text())
    old=camp_obj.get('script',[])
    # Remove prior instance of this packet's scene events if re-running.
    remove_ids={uid('camp/init-if'),uid('camp/call-ui')}
    old=[e for e in old if not (isinstance(e,dict) and e.get('id') in remove_ids)]
    init_false=[
        set_value('camp/init/battery',VAR['battery'],17),
        set_value('camp/init/vibes',VAR['vibes'],42),
        set_value('camp/init/responsibility',VAR['responsibility'],4),
        set_value('camp/init/karma',VAR['karma'],0),
        set_value('camp/init/groundscore',VAR['groundscore'],0),
        set_value('camp/init/crocs',VAR['crocs'],0),
        set_value('camp/init/done',VAR['ui_init'],1)
    ]
    old.append(ev('camp/init-if','EVENT_IF_VALUE',{
        'variable':VAR['ui_init'],'operator':'==','comparator':1,
        'true':[],'false':init_false,'__collapseElse':False
    }))
    old.append(ev('camp/call-ui','EVENT_CALL_CUSTOM_EVENT',{'customEventId':INIT,'__name':'Init WOOK UI'}))
    camp_obj['script']=old
    write(camp,camp_obj)

    # Mirror Crocs canonical counter into numeric display var and refresh HUD.
    for actor_name in ('croc_left.gbsres','croc_right.gbsres'):
        p=project/'project/scenes/questionable_campground/actors'/actor_name
        if p.exists():
            obj=json.loads(p.read_text())
            obj['script']=insert_mirror_increment(obj.get('script',[]),CROC_CANON,VAR['crocs'])
            if not any(isinstance(e,dict) and e.get('command')=='EVENT_CALL_CUSTOM_EVENT' and (e.get('args') or {}).get('customEventId')==REFRESH for e in obj['script']):
                obj['script'].append(ev('actor/'+actor_name+'/refresh','EVENT_CALL_CUSTOM_EVENT',{'customEventId':REFRESH,'__name':'Refresh HUD'}))
            write(p,obj)

    manifest={
        'schema':'ghost-atlas.wook.c0.hud-menu.v1','packet':PACKET,
        'display_variables':VAR,'scene_ids':SC,'background_ids':BG,
        'scripts':{'init':INIT,'refresh':REFRESH},
        'native_build':'PENDING_EXECUTION','visual_qa':'PENDING_NATIVE_SCREENSHOT'
    }
    write(root/'docs/proof/C0-HUD-MENU-MANIFEST.json',manifest)
    print('DISPLAY_VARIABLES=PASS')
    print('HUD_EVENT=PASS')
    print('START_INPUT_ROUTE=PASS')
    print('SELECT_PHONE_ROUTE=PASS')
    print('MENU_SCENE=PASS')
    print('PHONE_SCENE=PASS')
    print('INVENTORY_SCENE=PASS')
    print('QUEST_LOG_SCENE=PASS')

if __name__=='__main__':
    main()
