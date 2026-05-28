const ORIGIN = "sowton park and ride exeter";

const TEAMS = [
  {num:1, name:"Ashmoor M2",             venue:"Ashmoor Hockey Club",          addr:"Ashburton Rd, Totnes TQ9 5JX",       lat:50.43798, lng:-3.69145, miles:24, mins:35},
  {num:2, name:"Falmouth M1",            venue:"Penryn College",               addr:"Kernick Rd, Penryn TR10 8PZ",        lat:50.16816, lng:-5.11494, miles:94, mins:125},
  {num:3, name:"Isca M4",                venue:"Exeter University Sports Park", addr:"Stocker Rd, Exeter EX4 4QL",          lat:50.73770, lng:-3.53690, miles:5,  mins:18, home:true},
  {num:4, name:"North Devon M1",         venue:"The Park Community School",     addr:"Park Lane, Barnstaple EX32 9AX",     lat:51.06828, lng:-4.04988, miles:46, mins:60},
  {num:5, name:"Plymouth Lions M2",      venue:"Plymouth Marjon Hockey Centre", addr:"Derriford Rd, Plymouth PL6 8BH",     lat:50.42008, lng:-4.11288, miles:46, mins:55},
  {num:6, name:"Sidmouth & Ottery M1",   venue:"Ottery Leisure Centre",         addr:"Cadhay Ln, Ottery St Mary EX11 1QW", lat:50.75012, lng:-3.29394, miles:12, mins:25},
  {num:7, name:"Torbay M1",              venue:"Torbay Hockey Club",            addr:"Shiphay Ave, Torquay TQ2 7EA",       lat:50.47742, lng:-3.55842, miles:23, mins:38},
  {num:8, name:"Truro M2",               venue:"Truro Hockey Club (Richard Lander School)", addr:"Trennick Ln, Truro TR1 1TH", lat:50.26078, lng:-5.04189, miles:86, mins:110},
  {num:9, name:"University of Exeter M4", venue:"Exeter University Sports Park", addr:"Stocker Rd, Exeter EX4 4QL",          lat:50.73830, lng:-3.53760, miles:5,  mins:18, home:true},
  {num:10,name:"University of Exeter M6", venue:"Exeter University Sports Park", addr:"Stocker Rd, Exeter EX4 4QL",          lat:50.73880, lng:-3.53620, miles:5,  mins:18, home:true},
  {num:11,name:"Uni. of Plymouth M1",    venue:"Lipson Co-op Academy",          addr:"Bernice Terrace, Plymouth PL4 7PG",  lat:50.38080, lng:-4.12330, miles:44, mins:58, guess:true},
];

function dirUrl(t){
  const enc = s => encodeURIComponent(s.trim());
  return `https://www.google.com/maps/dir/?api=1&origin=${enc(ORIGIN)}&destination=${enc(t.venue + ", " + t.addr)}`;
}
function fmtTime(m){
  if(m<60) return m + " min";
  const h=Math.floor(m/60), r=m%60;
  return r ? `${h}h ${r}m` : `${h}h`;
}

const map = L.map('map',{scrollWheelZoom:true}).setView([50.6,-4.0],8);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{maxZoom:18,attribution:'&copy; OpenStreetMap'}).addTo(map);

const ORIGIN_LL=[50.7280,-3.4730];
L.circleMarker(ORIGIN_LL,{radius:7,color:'#fff',weight:2,fillColor:'#222',fillOpacity:1})
 .addTo(map).bindPopup('<div class="pop-team">Sowton Park &amp; Ride</div><div class="pop-venue">Your start point</div>');

const markers={};
function pinIcon(t){
  const bg = t.home ? '#1b7a3d' : '#7a1228';
  return L.divIcon({className:'',iconSize:[28,28],iconAnchor:[14,28],popupAnchor:[0,-26],
    html:`<div class="pin-inner" style="background:${bg}"><span>${t.num}</span></div>`});
}
const bounds=[ORIGIN_LL];
TEAMS.forEach(t=>{
  const m=L.marker([t.lat,t.lng],{icon:pinIcon(t)}).addTo(map);
  m.bindPopup(
    `<div class="pop-team">${t.name}</div>`+
    `<div class="pop-venue">${t.venue}<br>${t.addr}</div>`+
    `<div class="pop-meta">~${t.miles} mi &middot; ~${fmtTime(t.mins)}${t.home?' &middot; home pitch':''}${t.guess?' &middot; venue unconfirmed':''}</div>`+
    `<a class="pop-btn" target="_blank" rel="noopener" href="${dirUrl(t)}">Directions &#8599;</a>`
  );
  markers[t.num]=m;
  bounds.push([t.lat,t.lng]);
});

function fitAll(){ map.fitBounds(bounds,{padding:[40,40]}); }
fitAll();

const FitCtl = L.Control.extend({
  options:{position:'topright'},
  onAdd:function(){
    const b=L.DomUtil.create('button','fit-btn');
    b.type='button'; b.title='Show all pins'; b.innerHTML='&#10530; Fit all';
    L.DomEvent.disableClickPropagation(b);
    L.DomEvent.on(b,'click',e=>{L.DomEvent.stop(e); fitAll();});
    return b;
  }
});
map.addControl(new FitCtl());

const listEl=document.getElementById('list');
function render(sortKey){
  const arr=[...TEAMS].sort(sortKey==='dist'?(a,b)=>a.miles-b.miles||a.num-b.num:(a,b)=>a.num-b.num);
  listEl.innerHTML='';
  arr.forEach(t=>{
    const card=document.createElement('div');
    card.className='card'+(t.home?' home':'');
    card.innerHTML=
      `<div class="num">${t.num}</div>`+
      `<div class="info"><div class="team">${t.name}`+
        (t.home?'<span class="tag">home pitch</span>':'')+
        (t.guess?'<span class="tag warn">check</span>':'')+
      `</div><div class="venue">${t.venue} &middot; ${t.addr.split(',').pop().trim()}</div></div>`+
      `<div class="meta"><div class="dist">${t.miles} mi</div><div class="time">~${fmtTime(t.mins)}</div></div>`+
      `<a class="dir" target="_blank" rel="noopener" href="${dirUrl(t)}" title="Directions" aria-label="Directions">&#10140;</a>`;
    card.addEventListener('click',e=>{
      if(e.target.closest('.dir')) return;
      document.getElementById('map').scrollIntoView({behavior:'smooth',block:'start'});
      map.setView([t.lat,t.lng], t.home?14:11, {animate:true});
      markers[t.num].openPopup();
      card.classList.add('flash');
      setTimeout(()=>card.classList.remove('flash'),900);
    });
    listEl.appendChild(card);
  });
}
render('dist');

const bDist=document.getElementById('sortDist'), bLeague=document.getElementById('sortLeague');
bDist.onclick=()=>{render('dist');bDist.classList.add('on');bLeague.classList.remove('on')};
bLeague.onclick=()=>{render('league');bLeague.classList.add('on');bDist.classList.remove('on')};

if('serviceWorker' in navigator){
  window.addEventListener('load',()=>navigator.serviceWorker.register('sw.js').catch(()=>{}));
}

const APP_VERSION = "2026-05-28";   // bump this each time you deploy
const ver = document.createElement("div");
ver.style.cssText = "text-align:center;font-size:11px;color:#9c8e90;padding:4px 0 24px";
ver.textContent = "build " + APP_VERSION;
document.querySelector(".wrap").appendChild(ver);
