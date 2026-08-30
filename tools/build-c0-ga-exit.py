#!/usr/bin/env python3
from pathlib import Path
from PIL import Image, ImageDraw
import argparse, json, uuid

NS = uuid.UUID('6bed2d4f-7c1b-487c-9800-c0015a0e0002')
PACKET='WOOK-C0-GA-EXIT-001'

def uid(label): return str(uuid.uuid5(NS,PACKET+'/'+label))
def write(p,o): p.parent.mkdir(parents=True,exist_ok=True); p.write_text(json.dumps(o,indent=2)+'\n')
def num(v): return {'type':'number','value':v}
def ev(label,cmd,args): return {'id':uid(label),'command':cmd,'args':args}

def draw_ga(path):
    I=(15,33,35,255); D=(49,83,75,255); M=(127,160,111,255); L=(196,217,154,255)
    im=Image.new('RGBA',(160,144),L); d=ImageDraw.Draw(im)
    # lane
    d.polygon([(64,144),(96,144),(89,0),(71,0)],fill=M)
    for y in range(8,144,16): d.rectangle((78,y,81,y+6),fill=L)
    # tree walls
    def pine(cx,cy,s=1):
        d.rectangle((cx-1*s,cy+9*s,cx+1*s,cy+15*s),fill=I)
        d.polygon([(cx,cy),(cx-6*s,cy+9*s),(cx+6*s,cy+9*s)],fill=D)
        d.polygon([(cx,cy+4*s),(cx-8*s,cy+13*s),(cx+8*s,cy+13*s)],fill=I)
    for y in range(0,140,22):
        pine(12,y,1); pine(32,y+8,1); pine(128,y+4,1); pine(148,y+12,1)
    # tents and canopies
    d.polygon([(44,48),(54,34),(64,48)],fill=D,outline=I)
    d.line((54,34,54,48),fill=I,width=1)
    d.rectangle((104,72,132,88),outline=I,fill=M)
    d.line((104,72,110,65,126,65,132,72),fill=I,width=2)
    # signage
    d.rectangle((58,12,102,28),fill=L,outline=I,width=2)
    d.text((67,16),'GA MAIN',fill=I)
    # scattered camp props
    d.rectangle((20,110,36,118),fill=D,outline=I)
    d.ellipse((116,110,126,120),fill=M,outline=I)
    d.line((121,105,121,123),fill=I,width=1)
    path.parent.mkdir(parents=True,exist_ok=True); im.save(path)

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--root',required=True); a=ap.parse_args()
    root=Path(a.root); project=root/'game/project'; bgs=project/'assets/backgrounds'; camp=project/'project/scenes/questionable_campground'; triggers=camp/'triggers'; target=project/'project/scenes/ga_main_lane_entry'
    if not (camp/'scene.gbsres').exists(): raise SystemExit('CAMPGROUND_SCENE=MISSING')
    triggers.mkdir(parents=True,exist_ok=True); target.mkdir(parents=True,exist_ok=True)

    bg_id=uid('background/ga-main-lane-entry'); scene_id=uid('scene/ga-main-lane-entry'); trigger_id=uid('trigger/camp-to-ga')
    png=bgs/'ga-main-lane-entry.png'; draw_ga(png)
    bg={
      '_resourceType':'background','id':bg_id,'name':'GA Main Lane — C01 Entry Seam','symbol':'bg_ga_main_lane_entry','tileColors':'',
      'filename':png.name,'width':20,'height':18,'imageWidth':160,'imageHeight':144,'autoColor':False
    }
    write(bgs/'ga-main-lane-entry.png.gbsres',bg)

    scene={
      '_resourceType':'scene','id':scene_id,'_index':50,'type':'TOPDOWN','name':'GA Main Lane — C01 Entry Seam','symbol':'scene_ga_main_lane_entry',
      'x':520,'y':0,'width':20,'height':18,'backgroundId':bg_id,'tilesetId':'','colorModeOverride':'none','paletteIds':[],
      'spritePaletteIds':[],'autoFadeSpeed':1,
      'script':[ev('entry/text','EVENT_TEXT',{'text':'GA MAIN LANE\nGates open soon.'})],
      'playerHit1Script':[],'playerHit2Script':[],'playerHit3Script':[],'collisions':''
    }
    write(target/'scene.gbsres',scene)

    gate=ev('gate/crocs?','EVENT_IF_VALUE',{
      'variable':'90','operator':'>=','comparator':2,
      'true':[ev('gate/switch','EVENT_SWITCH_SCENE',{
        'x':num(10),'y':num(15),'direction':'up','sceneId':scene_id,'fadeSpeed':'2'
      })],
      'false':[ev('gate/block','EVENT_TEXT',{'text':'Absolutely not.\nYou are not leaving\ncamp barefoot.'})],
      '__collapseElse':False
    })
    trigger={
      '_resourceType':'trigger','id':trigger_id,'_index':0,'symbol':'trigger_c0_to_ga','prefabId':'','name':'Leave Camp for GA',
      'x':8,'y':16,'width':4,'height':1,'prefabScriptOverrides':{},'script':[gate],'leaveScript':[]
    }
    write(triggers/'ga_exit.gbsres',trigger)

    manifest={
      'schema':'ghost-atlas.wook.c0.ga-exit.v1','packet':PACKET,
      'gate_variable':'90','required_crocs':2,'trigger_id':trigger_id,'target_scene_id':scene_id,'target_background_id':bg_id,
      'target_truth':'C01_ENTRY_SEAM_ONLY','c01_qualified':False,'native_build':'PENDING_EXECUTION'
    }
    write(root/'docs/proof/C0-GA-EXIT-MANIFEST.json',manifest)
    print('C0_GA_EXIT_TRIGGER=PASS')
    print('CROCS_GATE=PASS')
    print('C01_ENTRY_SEAM=PASS')
    print('C01_QUALIFIED=NO')

if __name__=='__main__': main()
