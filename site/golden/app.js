(() => {
const c=document.getElementById("screen"),x=c.getContext("2d");x.imageSmoothingEnabled=false;
const A="assets/"; const imgs={}; const names=[
"act1-golden-campground.png","papa-wook.png","moonbeam-jessica.png","raccoon.png",
"title-screen.png","inventory-screen.png","phone-screen.png","raccoon-encounter.png",
"quest-complete.png","trader-screen.png","world-map.png","porta-potty-dungeon.png","drum-circle.png"
];
let loaded=0; names.forEach(n=>{let i=new Image();i.src=A+n;i.onload=()=>{imgs[n]=i;if(++loaded===names.length) boot();};});
let s={mode:"title",px:80,py:88,dir:0,battery:17,vibes:72,crocs:0,jessica:false,raccoon:false,quest:false,dialog:null,frame:0};
function img(n){return imgs[n]}
function sprite(sheet,frame,dx,dy){let sw=16, sx=(frame%(sheet.width/16))*16; x.drawImage(sheet,sx,0,16,16,dx,dy,16,16)}
function txt(t,px,py,col="#11150f",sz=7){x.fillStyle=col;x.font=`bold ${sz}px monospace`;x.fillText(t,px,py)}
function box(px,py,w,h){x.fillStyle="#dedab1";x.fillRect(px,py,w,h);x.strokeStyle="#11150f";x.lineWidth=2;x.strokeRect(px,py,w,h);x.strokeStyle="#61674b";x.lineWidth=1;x.strokeRect(px+3,py+3,w-6,h-6)}
function world(){
 x.drawImage(img("act1-golden-campground.png"),0,0);
 // hud integrated
 box(3,3,54,20);txt(`BAT ${s.battery}%`,7,11);txt(`VIB ${s.vibes}  CROCS ${s.crocs}/2`,7,19,null,6);
 sprite(img("moonbeam-jessica.png"),0,119,40); sprite(img("raccoon.png"),0,34,96); sprite(img("papa-wook.png"),s.frame%8,s.px-8,s.py-8);
 if(s.dialog){box(4,103,152,37);txt(s.dialog.who,9,113,null,7);let lines=s.dialog.text.match(/.{1,34}(\s|$)/g)||[s.dialog.text];lines.slice(0,3).forEach((q,i)=>txt(q.trim(),9,123+i*8,null,6));}
}
function render(){
 x.clearRect(0,0,160,144);
 if(s.mode==="title")x.drawImage(img("title-screen.png"),0,0);
 else if(s.mode==="world")world();
 else if(s.mode==="inventory")x.drawImage(img("inventory-screen.png"),0,0);
 else if(s.mode==="phone")x.drawImage(img("phone-screen.png"),0,0);
 else if(s.mode==="encounter")x.drawImage(img("raccoon-encounter.png"),0,0);
 else if(s.mode==="complete")x.drawImage(img("quest-complete.png"),0,0);
 else if(s.mode==="trader")x.drawImage(img("trader-screen.png"),0,0);
 else if(s.mode==="map")x.drawImage(img("world-map.png"),0,0);
 else if(s.mode==="dungeon")x.drawImage(img("porta-potty-dungeon.png"),0,0);
 else if(s.mode==="drum")x.drawImage(img("drum-circle.png"),0,0);
 requestAnimationFrame(render);
}
function say(who,text){s.dialog={who,text}}
function interact(){
 if(s.dialog){s.dialog=null;return}
 if(Math.hypot(s.px-127,s.py-48)<25 && !s.jessica){s.jessica=true;s.crocs++;say("MOONBEAM JESSICA","Oh my god. You finally woke up. Also, this Croc is apparently yours.");return}
 if(Math.hypot(s.px-42,s.py-104)<22 && !s.raccoon){s.mode="encounter";return}
 if(Math.hypot(s.px-130,s.py-72)<20 && s.crocs<2){s.crocs++;say("SYSTEM","ITEM FOUND! CROC (RIGHT). It smells like enlightenment and questionable choices.");if(s.crocs===2)s.quest=true;return}
 if(s.quest){s.mode="complete";return}
 say("PAPA WOOK","Nothing here is currently asking to become a quest. Suspicious.");
}
function press(k){
 if(s.mode==="title"){if(k==="a"||k==="start"){s.mode="world";say("SYSTEM","You wake up. Your Crocs are gone. Your phone is at 17%. Somehow, this is everyone else's fault.")}return}
 if(s.mode==="encounter"){if(k==="a"){s.raccoon=true;s.vibes+=5;s.mode="world";say("SYSTEM","Diplomacy succeeds. The raccoon accepts a snack and your boundaries.")}else if(k==="b")s.mode="world";return}
 if(["inventory","phone","complete","trader","map","dungeon","drum"].includes(s.mode)){if(k==="b"||k==="a")s.mode="world";return}
 if(k==="a"){interact();return}
 if(k==="b"){s.mode="inventory";return}
 if(k==="phone"){s.battery=Math.max(0,s.battery-1);s.mode="phone";return}
 if(k==="start"){s.mode="map";return}
 if(k==="up")s.py-=4;if(k==="down")s.py+=4;if(k==="left")s.px-=4;if(k==="right")s.px+=4;
 s.px=Math.max(12,Math.min(148,s.px));s.py=Math.max(23,Math.min(132,s.py));s.frame=(s.frame+1)%8;
}
document.querySelectorAll("[data-key]").forEach(b=>{b.addEventListener("pointerdown",e=>{e.preventDefault();press(b.dataset.key)})});
window.addEventListener("keydown",e=>{let m={ArrowUp:"up",ArrowDown:"down",ArrowLeft:"left",ArrowRight:"right",z:"a",x:"b",Enter:"start",p:"phone"};if(m[e.key]){e.preventDefault();press(m[e.key])}});
function boot(){render()}
})();