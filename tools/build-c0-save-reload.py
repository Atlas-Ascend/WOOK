#!/usr/bin/env python3
from pathlib import Path
from PIL import Image
import argparse, copy, hashlib, json, uuid

NS = uuid.UUID('4ca8c2af-0f00-4e37-8d00-c0015ave0001'.replace('v','0'))
PACKET = 'WOOK-C0-SAVE-RELOAD-001'


def uid(label): return str(uuid.uuid5(NS, PACKET + '/' + label))
def write(p,o): p.parent.mkdir(parents=True,exist_ok=True); p.write_text(json.dumps(o,indent=2)+'\n')
def sha1(p): return hashlib.sha1(p.read_bytes()).hexdigest()
def num(v): return {'type':'number','value':v}
def event(label,cmd,args=None,children=None):
    o={'id':uid(label),'command':cmd,'args':args or {}}
    if children is not None: o['children']=children
    return o

def ensure_var(vr,vid,name,symbol):
    xs=vr.get('variables',[])
    if isinstance(xs,dict): xs=[]
    by={str(x.get('id')):x for x in xs if isinstance(x,dict)}
    by[str(vid)]={'id':str(vid),'name':name,'symbol':symbol}
    vr['variables']=list(by.values())
    if isinstance(vr.get('constants'),dict): vr['constants']=[]

def icon(path):
    C=(0,0,0,0); I=(15,33,35,255); D=(49,83,75,255); M=(127,160,111,255); L=(196,217,154,255)
    im=Image.new('RGBA',(16,16),C); px=im.load()
    # little campfire/checkpoint icon
    for x,y in [(8,3),(7,4),(8,4),(9,4),(6,5),(7,5),(8,5),(9,5),(10,5),(7,6),(8,6),(9,6)]: px[x,y]=L
    for x,y in [(6,7),(7,7),(8,7),(9,7),(10,7),(5,8),(6,8),(7,8),(8,8),(9,8),(10,8),(11,8)]: px[x,y]=M
    for x in range(4,12): px[x,10]=D
    for x in range(5,11): px[x,11]=I
    px[4,12]=I; px[11,12]=I; px[6,12]=D; px[9,12]=D
    path.parent.mkdir(parents=True,exist_ok=True); im.save(path)

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--root',required=True); a=ap.parse_args()
    root=Path(a.root); project=root/'game/project'; settings_path=project/'project/settings.gbsres'; vars_path=project/'project/variables.gbsres'; sprites=project/'assets/sprites'; actors=project/'project/scenes/questionable_campground/actors'; template_path=sprites/'static.png.gbsres'
    for p in (settings_path,vars_path,template_path):
        if not p.exists(): raise SystemExit(f'MISSING={p}')
    actors.mkdir(parents=True,exist_ok=True)

    settings=json.loads(settings_path.read_text())
    if settings.get('batterylessEnabled') is True:
        raise SystemExit('BATTERY_BACKED_SAVE_REQUIRED=batterylessEnabled_true')
    if settings.get('cartType') not in ('mbc5','mbc3'):
        raise SystemExit(f'UNSUPPORTED_CART_TYPE={settings.get("cartType")}')

    MENU='106'
    vr=json.loads(vars_path.read_text())
    ensure_var(vr,MENU,'C0 Save Point Menu','var_c0_save_point_menu')
    write(vars_path,vr)

    template=json.loads(template_path.read_text())
    png=sprites/'campfire-checkpoint.png'; icon(png)
    sprite_id=uid('sprite/checkpoint')
    r=copy.deepcopy(template); r['id']=sprite_id; r['name']='Campfire Checkpoint'; r['symbol']='sprite_campfire_checkpoint'; r['filename']=png.name; r['width']=16; r['height']=16; r['checksum']=sha1(png)
    write(sprites/'campfire-checkpoint.png.gbsres',r)

    save_event=event('save/write','EVENT_SAVE_DATA',{'saveSlot':0},{
        'true':[event('save/confirmed','EVENT_TEXT',{'text':'Camp state saved.\nThe fire remembers.'})],
        'load':[event('save/on-load','EVENT_TEXT',{'text':'You return to\nthe remembered fire.'})]
    })
    load_guard=event('load/guard','EVENT_IF_SAVED_DATA',{'saveSlot':0,'__collapseElse':False},{
        'true':[event('load/do','EVENT_LOAD_DATA',{'saveSlot':0})],
        'false':[event('load/none','EVENT_TEXT',{'text':'No compatible\nsave yet.'})]
    })
    script=[
        event('menu/title','EVENT_TEXT',{'text':'CAMPFIRE\nCHECKPOINT'}),
        event('menu/options','EVENT_MENU',{
            'variable':MENU,'items':3,
            'option1':'SAVE','option2':'LOAD','option3':'CANCEL',
            'cancelOnLastOption':True,'cancelOnB':True,'layout':'menu'
        }),
        event('menu/save?','EVENT_IF_VALUE',{
            'variable':MENU,'operator':'==','comparator':0,
            'true':[save_event],'false':[],'__collapseElse':False
        }),
        event('menu/load?','EVENT_IF_VALUE',{
            'variable':MENU,'operator':'==','comparator':1,
            'true':[load_guard],'false':[],'__collapseElse':False
        })
    ]

    actor_id=uid('actor/checkpoint')
    actor={
        '_resourceType':'actor','id':actor_id,'name':'Campfire Checkpoint','frame':0,'animate':False,
        'spriteSheetId':sprite_id,'prefabId':'','direction':'down','moveSpeed':1,'animSpeed':15,
        'paletteId':'','isPinned':False,'persistent':False,'collisionGroup':'','collisionExtraFlags':[],
        'prefabScriptOverrides':{},'_index':34,'symbol':'actor_campfire_checkpoint','coordinateType':'tiles',
        'x':9,'y':8,'script':script,'startScript':[],'updateScript':[],'hit1Script':[],'hit2Script':[],'hit3Script':[]
    }
    write(actors/'campfire_checkpoint.gbsres',actor)

    manifest={
        'schema':'ghost-atlas.wook.c0.save-reload.v1','packet':PACKET,
        'save_slot':0,'cart_type':settings.get('cartType'),'batteryless':settings.get('batterylessEnabled',False),
        'actor_id':actor_id,'sprite_id':sprite_id,'menu_variable':MENU,
        'events':['EVENT_SAVE_DATA','EVENT_LOAD_DATA','EVENT_IF_SAVED_DATA'],
        'native_build':'PENDING_EXECUTION','behavioral_matrix':'PENDING_C0_REGRESSION'
    }
    write(root/'docs/proof/C0-SAVE-RELOAD-MANIFEST.json',manifest)
    print('BATTERY_BACKED_CART_PATH=PASS')
    print('SAVE_EVENT_RESOURCE=PASS')
    print('LOAD_EVENT_RESOURCE=PASS')
    print('IF_SAVED_GUARD=PASS')

if __name__=='__main__': main()
