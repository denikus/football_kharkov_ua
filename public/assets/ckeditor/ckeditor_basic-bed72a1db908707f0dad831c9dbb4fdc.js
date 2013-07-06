/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
(function(){window.CKEDITOR||(window.CKEDITOR=function(){var a={timestamp:"B1GG4Z6",version:"3.5.2",revision:"6450",_:{},status:"unloaded",basePath:function(){var a=window.CKEDITOR_BASEPATH||"";if(!a){var b=document.getElementsByTagName("script");for(var c=0;c<b.length;c++){var d=b[c].src.match(/(^|.*[\\\/])ckeditor(?:_basic)?(?:_source)?.js(?:\?.*)?$/i);if(d){a=d[1];break}}}a.indexOf(":/")==-1&&(a.indexOf("/")===0?a=location.href.match(/^.*?:\/\/[^\/]*/)[0]+a:a=location.href.match(/^[^\?]*\/(?:)/)[0]+a);if(!a)throw'The CKEditor installation path could not be automatically detected. Please set the global variable "CKEDITOR_BASEPATH" before creating editor instances.';return a}(),getUrl:function(a){return a.indexOf(":/")==-1&&a.indexOf("/")!==0&&(a=this.basePath+a),this.timestamp&&a.charAt(a.length-1)!="/"&&!/[&?]t=/.test(a)&&(a+=(a.indexOf("?")>=0?"&":"?")+"t="+this.timestamp),a}},b=window.CKEDITOR_GETURL;if(b){var c=a.getUrl;a.getUrl=function(d){return b.call(a,d)||c.call(a,d)}}return a}());var a=CKEDITOR;a.event||(a.event=function(){},a.event.implementOn=function(b){var c=a.event.prototype;for(var d in c)b[d]==undefined&&(b[d]=c[d])},a.event.prototype=function(){var a=function(a){var b=a.getPrivate&&a.getPrivate()||a._||(a._={});return b.events||(b.events={})},b=function(a){this.name=a,this.listeners=[]};return b.prototype={getListenerIndex:function(a){for(var b=0,c=this.listeners;b<c.length;b++)if(c[b].fn==a)return b;return-1}},{on:function(c,d,e,f,g){var h=a(this),i=h[c]||(h[c]=new b(c));if(i.getListenerIndex(d)<0){var j=i.listeners;e||(e=this),isNaN(g)&&(g=10);var k=this,l=function(a,b,g,h){var i={name:c,sender:this,editor:a,data:b,listenerData:f,stop:g,cancel:h,removeListener:function(){k.removeListener(c,d)}};return d.call(e,i),i.data};l.fn=d,l.priority=g;for(var m=j.length-1;m>=0;m--)if(j[m].priority<=g){j.splice(m+1,0,l);return}j.unshift(l)}},fire:function(){var b=!1,c=function(){b=!0},d=!1,e=function(){d=!0};return function(h,i,j){var k=a(this)[h],l=b,m=d;b=d=!1;if(k){var n=k.listeners;if(n.length){n=n.slice(0);for(var o=0;o<n.length;o++){var p=n[o].call(this,j,i,c,e);typeof p!="undefined"&&(i=p);if(b||d)break}}}var q=d||(typeof i=="undefined"?!1:i);return b=l,d=m,q}}(),fireOnce:function(b,c,d){var e=this.fire(b,c,d);return delete a(this)[b],e},removeListener:function(b,c){var d=a(this)[b];if(d){var e=d.getListenerIndex(c);e>=0&&d.listeners.splice(e,1)}},hasListeners:function(b){var c=a(this)[b];return c&&c.listeners.length>0}}}()),a.editor||(a.ELEMENT_MODE_NONE=0,a.ELEMENT_MODE_REPLACE=1,a.ELEMENT_MODE_APPENDTO=2,a.editor=function(b,c,d,e){var f=this;f._={instanceConfig:b,element:c,data:e},f.elementMode=d||0,a.event.call(f),f._init()},a.editor.replace=function(b,c){var d=b;if(typeof d!="object"){d=document.getElementById(b),d&&d.tagName.toLowerCase()in{style:1,script:1,base:1,link:1,meta:1,title:1}&&(d=null);if(!d){var e=0,f=document.getElementsByName(b);while((d=f[e++])&&d.tagName.toLowerCase()!="textarea");}if(!d)throw'[CKEDITOR.editor.replace] The element with id or name "'+b+'" was not found.'}return d.style.visibility="hidden",new a.editor(c,d,1)},a.editor.appendTo=function(b,c,d){var e=b;if(typeof e!="object"){e=document.getElementById(b);if(!e)throw'[CKEDITOR.editor.appendTo] The element with id "'+b+'" was not found.'}return new a.editor(c,e,2,d)},a.editor.prototype={_init:function(){var b=a.editor._pending||(a.editor._pending=[]);b.push(this)},fire:function(b,c){return a.event.prototype.fire.call(this,b,c,this)},fireOnce:function(b,c){return a.event.prototype.fireOnce.call(this,b,c,this)}},a.event.implementOn(a.editor.prototype,!0)),a.env||(a.env=function(){var a=navigator.userAgent.toLowerCase(),b=window.opera,c={ie:!1,opera:!!b&&b.version,webkit:a.indexOf(" applewebkit/")>-1,air:a.indexOf(" adobeair/")>-1,mac:a.indexOf("macintosh")>-1,quirks:document.compatMode=="BackCompat",mobile:a.indexOf("mobile")>-1,isCustomDomain:function(){if(!this.ie)return!1;var a=document.domain,b=window.location.hostname;return a!=b&&a!="["+b+"]"}};c.gecko=navigator.product=="Gecko"&&!c.webkit&&!c.opera;var d=0;c.ie&&(d=parseFloat(a.match(/msie (\d+)/)[1]),c.ie8=!!document.documentMode,c.ie8Compat=document.documentMode==8,c.ie7Compat=d==7&&!document.documentMode||document.documentMode==7,c.ie6Compat=d<7||c.quirks);if(c.gecko){var e=a.match(/rv:([\d\.]+)/);e&&(e=e[1].split("."),d=e[0]*1e4+(e[1]||0)*100+ +(e[2]||0))}return c.opera&&(d=parseFloat(b.version())),c.air&&(d=parseFloat(a.match(/ adobeair\/(\d+)/)[1])),c.webkit&&(d=parseFloat(a.match(/ applewebkit\/(\d+)/)[1])),c.version=d,c.isCompatible=!c.mobile&&(c.ie&&d>=6||c.gecko&&d>=10801||c.opera&&d>=9.5||c.air&&d>=1||c.webkit&&d>=522||!1),c.cssClass="cke_browser_"+(c.ie?"ie":c.gecko?"gecko":c.opera?"opera":c.webkit?"webkit":"unknown"),c.quirks&&(c.cssClass+=" cke_browser_quirks"),c.ie&&(c.cssClass+=" cke_browser_ie"+(c.version<7?"6":c.version>=8?document.documentMode:"7"),c.quirks&&(c.cssClass+=" cke_browser_iequirks")),c.gecko&&d<10900&&(c.cssClass+=" cke_browser_gecko18"),c.air&&(c.cssClass+=" cke_browser_air"),c}());var b=a.env,c=b.ie;a.status=="unloaded"&&function(){a.event.implementOn(a),a.loadFullCore=function(){if(a.status!="basic_ready"){a.loadFullCore._load=1;return}delete a.loadFullCore;var b=document.createElement("script");b.type="text/javascript",b.src=a.basePath+"ckeditor.js",document.getElementsByTagName("head")[0].appendChild(b)},a.loadFullCoreTimeout=0,a.replaceClass="ckeditor",a.replaceByClassEnabled=1;var c=function(c,d,e,f){if(b.isCompatible){a.loadFullCore&&a.loadFullCore();var g=e(c,d,f);return a.add(g),g}return null};a.replace=function(b,e){return c(b,e,a.editor.replace)},a.appendTo=function(b,e,f){return c(b,e,a.editor.appendTo,f)},a.add=function(a){var b=this._.pending||(this._.pending=[]);b.push(a)},a.replaceAll=function(){var a=document.getElementsByTagName("textarea");for(var b=0;b<a.length;b++){var c=null,d=a[b],e=d.name;if(!d.name&&!d.id)continue;if(typeof arguments[0]=="string"){var f=new RegExp("(?:^|\\s)"+arguments[0]+"(?:$|\\s)");if(!f.test(d.className))continue}else if(typeof arguments[0]=="function"){c={};if(arguments[0](d,c)===!1)continue}this.replace(d,c)}},function(){var b=function(){var b=a.loadFullCore,c=a.loadFullCoreTimeout;a.replaceByClassEnabled&&a.replaceAll(a.replaceClass),a.status="basic_ready",b&&b._load?b():c&&setTimeout(function(){a.loadFullCore&&a.loadFullCore()},c*1e3)};window.addEventListener?window.addEventListener("load",b,!1):window.attachEvent&&window.attachEvent("onload",b)}(),a.status="basic_loaded"}()})()