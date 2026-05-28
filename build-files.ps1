<#
  build-files.ps1
  -----------------------------------------------------------------------------
  Generates all 6 files for the Isca M4 "Away Days" PWA.

  HOW TO USE:
    1. Clone your repo (if you haven't):
         git clone https://github.com/PhilOutram/isca-m4-hockey-app.git
    2. Save this file inside the repo folder and run it from there:
         cd isca-m4-hockey-app
         .\build-files.ps1
       (If PowerShell blocks it: run
         powershell -ExecutionPolicy Bypass -File .\build-files.ps1 )
    3. Commit and push:
         git add .
         git commit -m "Add Away Days PWA"
         git push
    4. GitHub repo -> Settings -> Pages -> Deploy from a branch ->
       main / (root). Live at:
         https://philoutram.github.io/isca-m4-hockey-app/
  -----------------------------------------------------------------------------
#>

function Write-File([string]$Name, [string]$Content) {
  $enc  = New-Object System.Text.UTF8Encoding($false)   # UTF-8, no BOM
  $path = Join-Path (Get-Location) $Name
  [System.IO.File]::WriteAllText($path, $Content, $enc)
  Write-Host "  wrote $Name"
}

Write-Host "Creating files in $(Get-Location) ..."

# ----------------------------------------------------------------------------- index.html
Write-File 'index.html' @'
<!doctype html>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>Div 2 South — Away Days</title>
<meta name="theme-color" content="#7a1228">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-title" content="Away Days">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<link rel="manifest" href="manifest.webmanifest">
<link rel="icon" href="icon.svg">
<link rel="apple-touch-icon" href="icon.svg">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.min.css">
<link rel="stylesheet" href="styles.css">

<header>
  <h1><span>⚑</span> Div 2 South — Away Days</h1>
  <p class="sub">West Hockey 25/26 · all from <b>Sowton Park &amp; Ride, Exeter</b></p>
</header>

<div id="map"></div>

<div class="wrap">
  <div class="controls">
    <span class="lbl">Sort:</span>
    <div class="seg">
      <button id="sortDist" class="on">Nearest first</button>
      <button id="sortLeague">League order</button>
    </div>
  </div>
  <div id="list"></div>
  <p class="note">
    <b>Distances &amp; times are approximate.</b> Tap the directions button (or a pin) for live door-to-door figures from Google Maps.
    Isca, Exeter M4 &amp; M6 all play at the Exeter University Sports Park (pins nudged apart so they're tappable).
    Uni of Plymouth's venue (Lipson) is my best guess — check their fixtures.
  </p>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.min.js"></script>
<script src="app.js"></script>
'@

# ----------------------------------------------------------------------------- styles.css
Write-File 'styles.css' @'
:root{
  --maroon:#7a1228; --maroon-dk:#5c0d1e; --home:#1b7a3d;
  --bg:#fbf7f4; --card:#ffffff; --ink:#241a1c; --muted:#7c6c70; --line:#ecdfe0;
}
*{box-sizing:border-box}
html,body{margin:0;padding:0}
body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;
  background:var(--bg);color:var(--ink);-webkit-text-size-adjust:100%}
header{background:var(--maroon);color:#fff;padding:calc(14px + env(safe-area-inset-top)) 18px 14px;
  box-shadow:0 2px 10px rgba(0,0,0,.18)}
header h1{margin:0;font-size:18px;letter-spacing:.3px;display:flex;align-items:center;gap:8px}
header .sub{margin:3px 0 0;font-size:12.5px;opacity:.82}
header .sub b{font-weight:700}
#map{height:46vh;min-height:280px;width:100%;background:#dfe7ea;z-index:0}
.wrap{max-width:760px;margin:0 auto;padding:0 12px 40px}
.controls{display:flex;gap:8px;align-items:center;padding:12px 2px 6px}
.controls .lbl{font-size:12px;color:var(--muted);margin-right:auto}
.seg{display:inline-flex;border:1px solid var(--line);border-radius:999px;overflow:hidden;background:#fff}
.seg button{border:0;background:#fff;color:var(--maroon);font-size:12.5px;font-weight:600;
  padding:7px 13px;cursor:pointer;font-family:inherit}
.seg button.on{background:var(--maroon);color:#fff}
.card{background:var(--card);border:1px solid var(--line);border-radius:14px;padding:12px 13px;
  margin:9px 0;display:flex;gap:12px;align-items:center;box-shadow:0 1px 2px rgba(90,30,40,.05);
  cursor:pointer;transition:.12s}
.card:active{transform:scale(.992)}
.card.flash{box-shadow:0 0 0 2px var(--maroon)}
.num{flex:0 0 auto;width:32px;height:32px;border-radius:50%;display:grid;place-items:center;
  background:var(--maroon);color:#fff;font-weight:700;font-size:14px}
.card.home .num{background:var(--home)}
.info{flex:1 1 auto;min-width:0}
.team{font-weight:700;font-size:15px;line-height:1.2}
.venue{font-size:12.5px;color:var(--muted);margin-top:2px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.tag{display:inline-block;font-size:10px;font-weight:700;color:var(--home);border:1px solid var(--home);
  border-radius:6px;padding:0 5px;margin-left:6px;vertical-align:1px}
.tag.warn{color:#9a6b00;border-color:#d8b25a}
.meta{flex:0 0 auto;text-align:right}
.dist{font-weight:700;font-size:15px}
.time{font-size:12px;color:var(--muted)}
.dir{flex:0 0 auto;display:grid;place-items:center;width:42px;height:42px;border-radius:11px;
  background:var(--maroon);color:#fff;text-decoration:none;font-size:20px}
.dir:active{background:var(--maroon-dk)}
.note{font-size:11.5px;color:var(--muted);line-height:1.5;margin:14px 4px 0}
.note b{color:var(--ink)}
.pin-inner{width:28px;height:28px;border-radius:50% 50% 50% 0;transform:rotate(-45deg);
  border:2px solid #fff;box-shadow:0 2px 5px rgba(0,0,0,.35);display:grid;place-items:center}
.pin-inner span{transform:rotate(45deg);color:#fff;font-weight:700;font-size:13px;font-family:inherit}
.fit-btn{font-family:inherit;font-size:12.5px;font-weight:600;color:var(--maroon);background:#fff;
  border:1px solid var(--line);border-radius:9px;padding:7px 11px;cursor:pointer;box-shadow:0 1px 4px rgba(0,0,0,.25)}
.fit-btn:active{background:var(--maroon);color:#fff}
.leaflet-popup-content{margin:11px 13px;font-family:inherit}
.pop-team{font-weight:700;font-size:14px;color:var(--maroon)}
.pop-venue{font-size:12px;color:#555;margin:3px 0 7px;line-height:1.35}
.pop-meta{font-size:12px;color:#333;margin-bottom:8px}
.pop-btn{display:inline-block;background:var(--maroon);color:#fff !important;text-decoration:none;
  font-weight:600;font-size:12.5px;padding:7px 12px;border-radius:9px}
'@

# ----------------------------------------------------------------------------- app.js
Write-File 'app.js' @'
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
    `<div class="pop-meta">~${t.miles} mi · ~${fmtTime(t.mins)}${t.home?' · home pitch':''}${t.guess?' · venue unconfirmed':''}</div>`+
    `<a class="pop-btn" target="_blank" rel="noopener" href="${dirUrl(t)}">Directions ↗</a>`
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
    b.type='button'; b.title='Show all pins'; b.innerHTML='⤢ Fit all';
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
      `</div><div class="venue">${t.venue} · ${t.addr.split(',').pop().trim()}</div></div>`+
      `<div class="meta"><div class="dist">${t.miles} mi</div><div class="time">~${fmtTime(t.mins)}</div></div>`+
      `<a class="dir" target="_blank" rel="noopener" href="${dirUrl(t)}" title="Directions" aria-label="Directions">➜</a>`;
    card.addEventListener('click',e=>{
      if(e.target.closest('.dir')) return;
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
'@

# ----------------------------------------------------------------------------- manifest.webmanifest
Write-File 'manifest.webmanifest' @'
{
  "name": "Div 2 South — Away Days",
  "short_name": "Away Days",
  "start_url": ".",
  "scope": ".",
  "display": "standalone",
  "background_color": "#fbf7f4",
  "theme_color": "#7a1228",
  "icons": [
    { "src": "icon.svg", "sizes": "any", "type": "image/svg+xml", "purpose": "any maskable" }
  ]
}
'@

# ----------------------------------------------------------------------------- sw.js
Write-File 'sw.js' @'
const CACHE = "awaydays-v1";
const SHELL = ["./","./index.html","./styles.css","./app.js","./manifest.webmanifest","./icon.svg"];
self.addEventListener("install", e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)));
  self.skipWaiting();
});
self.addEventListener("activate", e => {
  e.waitUntil(caches.keys().then(k => Promise.all(k.filter(x => x !== CACHE).map(x => caches.delete(x)))));
  self.clients.claim();
});
self.addEventListener("fetch", e => {
  if (e.request.method !== "GET") return;
  e.respondWith(caches.match(e.request).then(r => r || fetch(e.request)));
});
'@

# ----------------------------------------------------------------------------- icon.svg
Write-File 'icon.svg' @'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <rect width="100" height="100" rx="22" fill="#7a1228"/>
  <line x1="34" y1="18" x2="34" y2="84" stroke="#fff" stroke-width="7" stroke-linecap="round"/>
  <path d="M37 22 L76 33 L37 44 Z" fill="#fff"/>
</svg>
'@

Write-Host ""
Write-Host "Done - 6 files written." -ForegroundColor Green
Write-Host "Next:"
Write-Host "  git add ."
Write-Host "  git commit -m ""Add Away Days PWA"""
Write-Host "  git push"
