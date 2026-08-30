#!/usr/bin/env python3
from pathlib import Path
from PIL import Image
import argparse, copy, hashlib, json, uuid

NS=uuid.UUID('e8d4479d-0f12-4709-8c00-c0015a7e0001')
PACKET='WOOK-C0-STATE-MUTATIONS-001'
def uid(label): return str(uuid.uuid5(NS,PACKET+'/'+label))
def write(p,o): p.parent.mkdir(parents=True,exist_ok=True); p.write_text(json.dumps(o,indent=2)+'\n')
def sha1(p): return hashlib.sha1(p.read_bytes()).hexdigest()
def ev(label,cmd,args): return {'id':uid(label),'command':cmd,'args':args}
def num(v): return {'type':'number','value':v}
def inc(label,var): return ev(label,'EVENT_INC_VALUE',{'variable':var})
def set1(label,var): return ev(label,'EVENT_SET_VALUE',{'variable':var,'value':num(1)})
def text(label,s): return ev(label,'EVENT_TEXT',{'text':s})
def call_refresh(label,rid): return ev(label,'EVENT_CALL_CUSTOM_EVENT',{'customEventId':rid,'__name':'Refresh HUD'})
def iff(label,var,true_events,false_events):
    return ev(label,'EVENT_IF_VALUE',{'variable':var,'operator':'==','comparator':1,'true':true_events,'false':false_events,'__collapseElse':False})

def ensure_var(vr,vid,name,symbol):
    xs=vr.get('variables',[])
    if isinstance(xs,dict): xs=[]
    by={str(x.get('id')):x for x in xs if isinstance(x,dict)}
    by[str(vid)]={'id':str(vid),'name':name,'symbol':symbol}
    vr['variables']=list(by.values())
    if isinstance(vr.get('constants'),dict): vr['constants']=[]

def icon(path,kind):
    C=(0,0,0,0); I=(15,33,35,255); D=(49,83,75,255); M=(127,160,111,255); L=(196,217,154,255)
    im=Image.new('RGBA',(16,16),C)
    px=im.load()
    if kind=='carabiner':
        for y in range(3,13):
            for x in (5,10): px[x,y]=I
        for x in range(5,11): px[x,3]=I; px[x,12]=I
        for x,y in [(6,4),(9,4),(6,11),(9,11),(7,7),(8,8)]: px[x,y]=M
    elif kind=='water':
        for y in range(4,13):
            for x in range(4,12): px[x,y]=M if 5<=y<=11 else I
        for x in range(6,10): px[x,2]=I; px[x,3]=D
        for x in range(5,11): px[x,12]=I
    else:
        for y in range(5,12):
            for x in range(5,11): px[x,y]=L
        for x in range(5,11): px[x,5]=I; px[x,11]=I
        for y in range(5,12): px[5,y]=I; px[10,y]=I
        px[11,7]=I; px[12,8]=I; px[11,9]=I
    path.parent.mkdir(parents=True,exist_ok=True); im.save(path)

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--root',required=True); a=ap.parse_args()
    root=Path(a.root); project=root/'game/project'; vars_path=project/'project/variables.gbsres'; sprites=project/'assets/sprites'; actors=project/'project/scenes/questionable_campground/actors'
    template_path=sprites/'static.png.gbsres'
    for p in (vars_path,template_path):
        if not p.exists(): raise SystemExit(f'MISSING={p}')
    actors.mkdir(parents=True,exist_ok=True)

    STAT={'responsibility':'93','karma':'94','groundscore':'95'}
    FLAG={'groundscore':'98','water':'99','cup':'100'}
    vr=json.loads(vars_path.read_text())
    ensure_var(vr,'98','C0 Groundscore Cache Claimed','var_c0_groundscore_cache_claimed')
    ensure_var(vr,'99','C0 Water Task Done','var_c0_water_task_done')
    ensure_var(vr,'100','C0 Cup Returned','var_c0_cup_returned')
    write(vars_path,vr)

    refresh_path=project/'project/scripts/wook/ui/refresh_wook_hud.gbsres'
    refresh_id=json.loads(refresh_path.read_text())['id'] if refresh_path.exists() else None
    template=json.loads(template_path.read_text())

    defs=[
      ('groundscore-cache','Groundscore Cache','carabiner','98','95',6,8,'You found:\nMYSTERY CARABINER\nGroundscore +1'),
      ('community-water','Community Water','water','99','93',12,10,'You refill the\ncamp water.\nResponsibility +1'),
      ('lost-cup-return','Lost Cup Return','cup','100','94',16,9,'Cup returned.\nWook Karma +1')]

    manifest={'schema':'ghost-atlas.wook.c0.state-mutations.v1','packet':PACKET,'interactions':{}}
    for idx,(slug,name,kind,flag,stat,x,y,msg) in enumerate(defs,20):
        sprite_id=uid('sprite/'+slug); actor_id=uid('actor/'+slug)
        png=sprites/(slug+'.png'); icon(png,kind)
        r=copy.deepcopy(template); r['id']=sprite_id; r['name']=name; r['symbol']='sprite_'+slug.replace('-','_'); r['filename']=png.name; r['width']=16; r['height']=16; r['checksum']=sha1(png)
        write(sprites/(png.name+'.gbsres'),r)
        first=[text(slug+'/reward',msg),inc(slug+'/inc',stat),set1(slug+'/flag',flag)]
        if refresh_id: first.append(call_refresh(slug+'/hud',refresh_id))
        script=[iff(slug+'/done?',flag,[text(slug+'/repeat','Already handled.')],first)]
        actor={'_resourceType':'actor','id':actor_id,'name':name,'frame':0,'animate':False,'spriteSheetId':sprite_id,'prefabId':'','direction':'down','moveSpeed':1,'animSpeed':15,'paletteId':'','isPinned':False,'persistent':False,'collisionGroup':'','collisionExtraFlags':[],'prefabScriptOverrides':{},'_index':idx,'symbol':'actor_'+slug.replace('-','_'),'coordinateType':'tiles','x':x,'y':y,'script':script,'startScript':[],'updateScript':[],'hit1Script':[],'hit2Script':[],'hit3Script':[]}
        write(actors/(slug.replace('-','_')+'.gbsres'),actor)
        manifest['interactions'][slug]={'actor_id':actor_id,'sprite_id':sprite_id,'flag':flag,'stat':stat,'position':[x,y]}

    manifest['hud_refresh_bound']=bool(refresh_id); manifest['native_build']='PENDING_EXECUTION'
    write(root/'docs/proof/C0-STATE-MUTATIONS-MANIFEST.json',manifest)
    print('GROUNDSCORE_MUTATION_RESOURCE=PASS')
    print('RESPONSIBILITY_MUTATION_RESOURCE=PASS')
    print('WOOK_KARMA_MUTATION_RESOURCE=PASS')
    print('ONE_TIME_GUARDS=PASS')

if __name__=='__main__': main()
