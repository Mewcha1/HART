
(function(){
function initTabs(){document.querySelectorAll('[data-tabs]').forEach(function(group){var buttons=group.querySelectorAll('.tab-button');var panels=group.querySelectorAll('.tab-panel');buttons.forEach(function(btn){btn.addEventListener('click',function(){buttons.forEach(b=>b.classList.remove('active'));panels.forEach(p=>p.classList.remove('active'));btn.classList.add('active');var panel=group.querySelector('[data-panel="'+btn.dataset.tab+'"]');if(panel)panel.classList.add('active');});});});}
function initAccordion(){var box=document.querySelector('[data-accordion]');if(!box)return;var details=box.querySelectorAll('details');details.forEach(function(d){d.addEventListener('toggle',function(){if(!d.open)return;details.forEach(function(other){if(other!==d)other.open=false;});});});}
function loadLeaflet(cb){if(window.L){cb();return;}var link=document.createElement('link');link.rel='stylesheet';link.href='https://unpkg.com/leaflet@1.9.4/dist/leaflet.css';link.crossOrigin='';document.head.appendChild(link);var script=document.createElement('script');script.src='https://unpkg.com/leaflet@1.9.4/dist/leaflet.js';script.crossOrigin='';script.onload=cb;document.head.appendChild(script);}
function initMap(){var el=document.getElementById('ha-map');if(!el)return;loadLeaflet(function(){
var exactExperimentalSite=[26.4623990,-81.4422680];
var map=L.map('ha-map',{scrollWheelZoom:true,zoomControl:true}).setView(exactExperimentalSite,18);
var imagery=L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',{maxZoom:19,attribution:'Tiles © Esri'}).addTo(map);
var labels=L.tileLayer('https://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',{maxZoom:19,attribution:'Labels © Esri'}).addTo(map);
var osm=L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{maxZoom:19,attribution:'© OpenStreetMap contributors'});
var experiment=L.layerGroup().addTo(map), watershed=L.layerGroup().addTo(map);
var experimentalMarker=L.marker(exactExperimentalSite,{title:'Exact Experimental Site'}).addTo(experiment);
experimentalMarker.bindPopup('<div class="ha-popup"><span class="task-tag">Experimental Site</span><h4>Experimental Site · UF/IFAS SWFREC</h4><p><b>Exact coordinates:</b> 26.4623990, -81.4422680</p><p>This pin marks the exact project experimental location supplied for the lysimeter- and field-scale studies.</p><p><a href="https://www.google.com/maps?q=26.4623990,-81.4422680" target="_blank" rel="noopener">Open this exact point in Google Maps ↗</a></p></div>');
function dot(lat,lon,title,tag,text,layer,fill){var m=L.circleMarker([lat,lon],{radius:9,weight:3,color:'#ffffff',fillColor:fill,fillOpacity:.95});m.bindPopup('<div class="ha-popup"><span class="task-tag">'+tag+'</span><h4>'+title+'</h4><p>'+text+'</p></div>');m.addTo(layer);return m;}
dot(27.22194,-81.87611,'Peace River Watershed','Watershed Site','Watershed-scale study area for nutrient-load upscaling and downstream scenario analysis.',watershed,'#2d718e');
L.control.layers({'Satellite · Esri World Imagery':imagery,'Streets · OpenStreetMap':osm},{'Place labels':labels,'Experimental Site':experiment,'Watershed Site':watershed},{collapsed:false}).addTo(map);
var views={experimental:{center:exactExperimentalSite,zoom:18},watershed:{center:[27.13,-81.82],zoom:9}};
document.querySelectorAll('[data-map-view]').forEach(function(btn){btn.addEventListener('click',function(){document.querySelectorAll('[data-map-view]').forEach(b=>b.classList.remove('active'));btn.classList.add('active');var v=views[btn.dataset.mapView];map.flyTo(v.center,v.zoom,{duration:.8});if(btn.dataset.mapView==='experimental'){setTimeout(function(){experimentalMarker.openPopup();},850);}});});
map.setView(views.experimental.center,views.experimental.zoom);
setTimeout(function(){map.invalidateSize();experimentalMarker.openPopup();},250);
});}
document.addEventListener('DOMContentLoaded',function(){initTabs();initAccordion();initMap();});
})();


// page-toc-preview: build the optional static preview's right-hand Contents panel.
document.addEventListener('DOMContentLoaded', function(){
  var toc = document.getElementById('page-toc');
  var main = document.querySelector('.main');
  if(!toc || !main) return;
  var heads = main.querySelectorAll('h2, h3');
  heads.forEach(function(h, i){
    if(!h.id){ h.id = 'section-' + i; }
    var a = document.createElement('a');
    a.href = '#' + h.id;
    a.textContent = h.textContent.trim();
    a.className = h.tagName === 'H3' ? 'level3' : 'level2';
    toc.appendChild(a);
  });
});
