#!/usr/bin/env python3
from pathlib import Path
from PIL import Image
from collections import deque
import argparse, copy, hashlib, json, uuid

NS = uuid.UUID('7d810a0c-7c3a-4d6c-8ea1-f02178b9c001')

def uid(label): return str(uuid.uuid5(NS, 'WOOK-C0-CROCS-COLLISION-001/' + label))
def sha1(p): return hashlib.sha1(p.read_bytes()).hexdigest()
def write(p,obj): p.parent.mkdir(parents=True,exist_ok=True); p.write_text(json.dumps(obj,indent=2)+'\n')

def compress8(arr):
    if not arr: return ''
    out=''; last=None; count=0
    def flush(v,n):
        if n==1: return f'{v%256:02x}!'
        return f'{v%256:02x}{n:x}+'
    for v in arr:
        if last is None: last=v; count=1
        elif v==last: count+=1
        else: out+=flush(last,count); last=v; count=1
    return out+flush(last,count)

def croc_png(path, mirror=False):
    C=(0,0,0,0); I=(15,33,35,255); D=(49,83,75,255); M=(127,160,111,255); L=(196,217,154,255)
    im=Image.new('RGBA',(16,16),C)
    pts=[]
    for y,row in enumerate([
        '................','................','................','................',
        '......DDD.......','....DDMMMDD.....','...DMMMMMMMD....','..DMMMMMMMMMD...',
        '..DMMDDDDMMMD...','..DMMMMMMMMMD...','...DDMMMMMDD....','....DDDDDDD.....',
        '.....D...D......','....II...II.....','................','................']):
        for x,ch in enumerate(row):
            if ch!='.': pts.append((x,y, {'I':I,'D':D,'M':M,'L':L}[ch]))
    for x,y,c in pts: im.putpixel((15-x if mirror else x,y),c)
    path.parent.mkdir(parents=True,exist_ok=True); im.save(path)

def value(t,v): return {'type':t,'value':v} if t=='number' else {'type':t}
def ev(label,cmd,args): return {'id':uid(label),'command':cmd,'args':args}
def setv(label,var,val): return ev(label,'EVENT_SET_VALUE',{'variable':var,'value':value('number',val)})
def settrue(label,var): return ev(label,'EVENT_SET_VALUE',{'variable':var,'value':value('true',True)})
def inc(label,var): return ev(label,'EVENT_INC_VALUE',{'variable':var})
def text(label,s): return ev(label,'EVENT_TEXT',{'text':s})
def deact(label): return ev(label,'EVENT_ACTOR_DEACTIVATE',{'actorId':'$self$'})
def iff(label,var,op,n,t,f=None): return ev(label,'EVENT_IF_VALUE',{'variable':var,'operator':op,'comparator':n,'true':t,'false':f or [],'__collapseElse':False})

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--root',required=True); args=ap.parse_args()
    root=Path(args.root); project=root/'game/project'; scene_dir=project/'project/scenes/questionable_campground'; scene_path=scene_dir/'scene.gbsres'; vars_path=project/'project/variables.gbsres'; sprites=project/'assets/sprites'
    topo=json.loads((root/'design/gameplay/C0-CAMPGROUND-TOPOLOGY.json').read_text())
    w,h=topo['width'],topo['height']; solid=topo['collision']['solid']; grid=[0]*(w*h)
    for ob in topo['collision']['obstacles']:
        x0,y0,x1,y1=ob['rect']
        for y in range(y0,y1+1):
            for x in range(x0,x1+1): grid[y*w+x]=solid
    nodes={k:tuple(v) for k,v in topo['nodes'].items()}
    for k,(x,y) in nodes.items():
        if not (0<=x<w and 0<=y<h) or grid[y*w+x]!=0: raise SystemExit(f'NODE_BLOCKED={k}:{x},{y}')
    def reachable(a,b):
        q=deque([a]); seen={a}
        while q:
            x,y=q.popleft()
            if (x,y)==b:return True
            for nx,ny in ((x+1,y),(x-1,y),(x,y+1),(x,y-1)):
                if 0<=nx<w and 0<=ny<h and grid[ny*w+nx]==0 and (nx,ny) not in seen:
                    seen.add((nx,ny)); q.append((nx,ny))
        return False
    for a,b in topo['required_routes']:
        if not reachable(nodes[a],nodes[b]): raise SystemExit(f'ROUTE_BLOCKED={a}->{b}')
    scene=json.loads(scene_path.read_text()); scene['collisions']=compress8(grid); write(scene_path,scene)

    VAR={
      'left':'c0000000-0000-4000-8000-000000000001','right':'c0000000-0000-4000-8000-000000000002','count':'c0000000-0000-4000-8000-000000000003','raccoon':'c0000000-0000-4000-8000-000000000004','venue':'c0000000-0000-4000-8000-000000000005','complete':'c0000000-0000-4000-8000-000000000006'}
    names={'left':'C0 Croc Left Found','right':'C0 Croc Right Found','count':'C0 Crocs Count','raccoon':'C0 Raccoon Resolved','venue':'C0 Venue Ready','complete':'C0 Shoes Quest Complete'}
    vr=json.loads(vars_path.read_text()); existing=vr.get('variables',[]); existing=[] if isinstance(existing,dict) else existing; byid={x.get('id'):x for x in existing if isinstance(x,dict)}
    for key,idv in VAR.items(): byid[idv]={'id':idv,'name':names[key],'symbol':'VAR_'+key.upper(),'flags':{}}
    vr['_resourceType']='variables'; vr['variables']=list(byid.values()); vr['constants']=[] if isinstance(vr.get('constants'),dict) else vr.get('constants',[]); write(vars_path,vr)

    # deterministic Croc pickup art/resources using proven static resource grammar
    template=json.loads((sprites/'static.png.gbsres').read_text())
    ids={'left_sprite':'a401bba1-1e10-4a44-9001-000000000011','right_sprite':'a401bba1-1e10-4a44-9001-000000000012','left_actor':'a401bba1-1e10-4a44-9001-000000001011','right_actor':'a401bba1-1e10-4a44-9001-000000001012'}
    def make_sprite(name,rid,mirror):
        png=sprites/(name+'.png'); croc_png(png,mirror); r=copy.deepcopy(template); r['id']=rid; r['name']=name.replace('-',' ').title(); r['symbol']='sprite_'+name.replace('-','_'); r['filename']=name+'.png'; r['width']=16; r['height']=16; r['checksum']=sha1(png); write(sprites/(name+'.png.gbsres'),r)
    make_sprite('croc-left',ids['left_sprite'],False); make_sprite('croc-right',ids['right_sprite'],True)

    def completion(prefix): return [iff(prefix+'/complete?',VAR['count'],'>=',2,[settrue(prefix+'/done',VAR['complete']),settrue(prefix+'/venue',VAR['venue']),text(prefix+'/ceremony','WHERE ARE MY SHOES?\nCOMPLETE!\nCROCS 2/2')])]
    left_pick=[text('left/found','You found a\nCROC (LEFT)!'),settrue('left/set',VAR['left']),inc('left/inc',VAR['count'])]+completion('left')+[deact('left/deactivate')]
    right_pick=[text('right/found','You recovered the\nCROC (RIGHT)!'),settrue('right/set',VAR['right']),inc('right/inc',VAR['count'])]+completion('right')+[deact('right/deactivate')]
    left_script=[iff('left/already?',VAR['left'],'==',1,[deact('left/already/deactivate')],left_pick)]
    right_script=[iff('right/already?',VAR['right'],'==',1,[deact('right/already/deactivate')],[iff('right/raccoon?',VAR['raccoon'],'==',1,right_pick,[text('right/claimed','The raccoon has\nclaimed this Croc.')])])]
    def actor(rid,name,sprite_id,x,y,script,index): return {'_resourceType':'actor','id':rid,'name':name,'frame':0,'animate':False,'spriteSheetId':sprite_id,'prefabId':'','direction':'down','moveSpeed':1,'animSpeed':15,'paletteId':'','isPinned':False,'persistent':False,'collisionGroup':'','collisionExtraFlags':[],'prefabScriptOverrides':{},'_index':index,'symbol':'actor_'+name.lower().replace(' ','_'),'coordinateType':'tiles','x':x,'y':y,'script':script,'startScript':[],'updateScript':[],'hit1Script':[],'hit2Script':[],'hit3Script':[]}
    write(scene_dir/'actors/croc_left.gbsres',actor(ids['left_actor'],'Croc Left',ids['left_sprite'],*nodes['croc_left'],left_script,10))
    write(scene_dir/'actors/croc_right.gbsres',actor(ids['right_actor'],'Croc Right',ids['right_sprite'],*nodes['croc_right'],right_script,11))

    # Patch raccoon resolution if prior character packet is materialized.
    rp=scene_dir/'actors/raccoon.gbsres'
    if rp.exists():
        r=json.loads(rp.read_text()); script=r.get('script',[])
        if not any(e.get('command')=='EVENT_SET_VALUE' and e.get('args',{}).get('variable')==VAR['raccoon'] for e in script): script.append(settrue('raccoon/resolved',VAR['raccoon']))
        r['script']=script; write(rp,r)

    manifest={'schema':'ghost-atlas.wook.c0.crocs-collision.v1','packet':'WOOK-C0-CROCS-COLLISION-001','variables':VAR,'nodes':topo['nodes'],'collision_cells':sum(1 for x in grid if x),'collision_string':scene['collisions'],'route_audit':'PASS','native_build':'PENDING_EXECUTION'}
    write(root/'docs/proof/C0-CROCS-COLLISION-MANIFEST.json',manifest)
    print('C0_CROCS_STATE_RESOURCES=PASS'); print('C0_COLLISION_TOPOLOGY=PASS'); print('C0_ROUTE_SAFETY=PASS')
if __name__=='__main__': main()
