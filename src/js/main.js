function copyAccount(){
const txt=[
'Angela Vargas',
'18622257-1',
'ANGE.VARGAST853@GMAIL.COM',
'Banco Falabella',
'Cuenta Corriente',
'1-980-362444-7',
].join('\n');
const s=document.querySelector('[onclick="copyAccount()"] span');
function ok(){if(s){s.textContent='¡Copiado!';setTimeout(()=>s.textContent='Copiar número de cuenta',2200)}}
function fail(){if(s){s.textContent='Error al copiar';setTimeout(()=>s.textContent='Copiar número de cuenta',2200)}}
function fallback(){
const ta=document.createElement('textarea');
ta.value=txt;ta.style.cssText='position:fixed;opacity:0;pointer-events:none;top:0;left:0';
document.body.appendChild(ta);ta.focus();ta.select();
try{document.execCommand('copy')?ok():fail()}catch(e){fail()}
document.body.removeChild(ta);
}
if(navigator.clipboard&&window.isSecureContext){navigator.clipboard.writeText(txt).then(ok).catch(fallback)}else{fallback()}
}
function addToCalendar(){
const ics=["BEGIN:VCALENDAR","VERSION:2.0","PRODID:-//Boda Angela Alvaro//ES","CALSCALE:GREGORIAN","BEGIN:VEVENT","UID:boda-angela-alvaro-2027@invitacion","DTSTAMP:20260101T000000Z","DTSTART:20270102T173000","DTEND:20270103T020000","SUMMARY:Boda de Angela & \u00c1lvaro","LOCATION:KO Eventos\, Cam. Al Volc\u00e1n 11815\, El Manzano\, San Jos\u00e9 de Maipo","DESCRIPTION:\u00a1Nos casamos! Te esperamos para celebrar juntos. C\u00f3digo de vestimenta: Formal.","END:VEVENT","END:VCALENDAR"].join("\r\n");
const blob=new Blob([ics],{type:"text/calendar;charset=utf-8"});
const url=URL.createObjectURL(blob);
const a=document.createElement("a");a.href=url;a.download="Boda-Angela-Alvaro.ics";
document.body.appendChild(a);a.click();document.body.removeChild(a);
setTimeout(()=>URL.revokeObjectURL(url),1000);
}
const W=new Date('2027-01-02T17:30:00');
function tick(){const x=W-new Date();if(x<=0){document.getElementById('d').textContent='00';return}
const d=Math.floor(x/864e5),h=Math.floor(x%864e5/36e5),m=Math.floor(x%36e5/6e4),s=Math.floor(x%6e4/1e3);
document.getElementById('d').textContent=String(d).padStart(2,'0');
document.getElementById('h').textContent=String(h).padStart(2,'0');
document.getElementById('m').textContent=String(m).padStart(2,'0');
document.getElementById('s').textContent=String(s).padStart(2,'0');}
tick();setInterval(tick,1000);
const io=new IntersectionObserver(e=>{e.forEach((t,i)=>{if(t.isIntersecting){setTimeout(()=>t.target.classList.add('in'),i*90);io.unobserve(t.target)}})},{threshold:.14});
document.querySelectorAll('.rv').forEach(el=>io.observe(el));