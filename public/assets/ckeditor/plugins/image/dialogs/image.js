/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
(function(){var a=function(a,b){function l(){var a=arguments,b=this.getContentElement("advanced","txtdlgGenStyle");b&&b.commit.apply(b,a),this.foreach(function(b){b.commit&&b.id!="txtdlgGenStyle"&&b.commit.apply(b,a)})}function n(a){if(m)return;m=1;var b=this.getDialog(),d=b.imageElement;if(d){this.commit(c,d),a=[].concat(a);var e=a.length,f;for(var g=0;g<e;g++)f=b.getContentElement.apply(b,a[g].split(":")),f&&f.setup(c,d)}m=0}var c=1,d=2,e=4,f=8,g=/^\s*(\d+)((px)|\%)?\s*$/i,h=/(^\s*(\d+)((px)|\%)?\s*$)|^$/i,i=/^\d+px$/,j=function(){var a=this.getValue(),b=this.getDialog(),c=a.match(g);c&&(c[2]=="%"&&o(b,!1),a=c[1]);if(b.lockRatio){var d=b.originalElement;d.getCustomData("isReady")=="true"&&(this.id=="txtHeight"?(a&&a!="0"&&(a=Math.round(d.$.width*(a/d.$.height))),isNaN(a)||b.setValueOf("info","txtWidth",a)):(a&&a!="0"&&(a=Math.round(d.$.height*(a/d.$.width))),isNaN(a)||b.setValueOf("info","txtHeight",a)))}k(b)},k=function(a){return!a.originalElement||!a.preview?1:(a.commitContent(e,a.preview),0)},m,o=function(a,b){var c=a.originalElement;if(!c)return null;var d=CKEDITOR.document.getById(v);if(c.getCustomData("isReady")=="true")if(b=="check"){var e=a.getValueOf("info","txtWidth"),f=a.getValueOf("info","txtHeight"),g=c.$.width*1e3/c.$.height,h=e*1e3/f;a.lockRatio=!1,!e&&!f?a.lockRatio=!0:!isNaN(g)&&!isNaN(h)&&Math.round(g)==Math.round(h)&&(a.lockRatio=!0)}else b!=undefined?a.lockRatio=b:a.lockRatio=!a.lockRatio;else b!="check"&&(a.lockRatio=!1);a.lockRatio?d.removeClass("cke_btn_unlocked"):d.addClass("cke_btn_unlocked");var i=a._.editor.lang.image,j=i[a.lockRatio?"unlockRatio":"lockRatio"];return d.setAttribute("title",j),d.getFirst().setText(j),a.lockRatio},p=function(a){var b=a.originalElement;b.getCustomData("isReady")=="true"&&(a.setValueOf("info","txtWidth",b.$.width),a.setValueOf("info","txtHeight",b.$.height)),k(a)},q=function(a,b){function d(a,b){var c=a.match(g);return c?(c[2]=="%"&&(c[1]+="%",o(e,!1)),c[1]):b}if(a!=c)return;var e=this.getDialog(),f="",h=this.id=="txtWidth"?"width":"height",i=b.getAttribute(h);i&&(f=d(i,f)),f=d(b.getStyle(h),f),this.setValue(f)},r,s=function(){var a=this.originalElement;a.setCustomData("isReady","true"),a.removeListener("load",s),a.removeListener("error",t),a.removeListener("abort",t),CKEDITOR.document.getById(x).setStyle("display","none"),this.dontResetSize||p(this),this.firstLoad&&CKEDITOR.tools.setTimeout(function(){o(this,"check")},0,this),this.firstLoad=!1,this.dontResetSize=!1},t=function(){var b=this,c=b.originalElement;c.removeListener("load",s),c.removeListener("error",t),c.removeListener("abort",t);var d=CKEDITOR.getUrl(a.skinPath+"images/noimage.png");b.preview&&b.preview.setAttribute("src",d),CKEDITOR.document.getById(x).setStyle("display","none"),o(b,!1)},u=function(a){return CKEDITOR.tools.getNextId()+"_"+a},v=u("btnLockSizes"),w=u("btnResetSize"),x=u("ImagePreviewLoader"),y=u("ImagePreviewBox"),z=u("previewLink"),A=u("previewImage");return{title:a.lang.image[b=="image"?"title":"titleButton"],minWidth:420,minHeight:360,onShow:function(){var a=this;a.imageElement=!1,a.linkElement=!1,a.imageEditMode=!1,a.linkEditMode=!1,a.lockRatio=!0,a.dontResetSize=!1,a.firstLoad=!0,a.addLink=!1;var e=a.getParentEditor(),f=a.getParentEditor().getSelection(),g=f.getSelectedElement(),h=g&&g.getAscendant("a");CKEDITOR.document.getById(x).setStyle("display","none"),r=new CKEDITOR.dom.element("img",e.document),a.preview=CKEDITOR.document.getById(A),a.originalElement=e.document.createElement("img"),a.originalElement.setAttribute("alt",""),a.originalElement.setCustomData("isReady","false");if(h){a.linkElement=h,a.linkEditMode=!0;var i=h.getChildren();if(i.count()==1){var j=i.getItem(0).getName();if(j=="img"||j=="input")a.imageElement=i.getItem(0),a.imageElement.getName()=="img"?a.imageEditMode="img":a.imageElement.getName()=="input"&&(a.imageEditMode="input")}b=="image"&&a.setupContent(d,h)}if(g&&g.getName()=="img"&&!g.data("cke-realelement")||g&&g.getName()=="input"&&g.getAttribute("type")=="image")a.imageEditMode=g.getName(),a.imageElement=g;a.imageEditMode?(a.cleanImageElement=a.imageElement,a.imageElement=a.cleanImageElement.clone(!0,!0),a.setupContent(c,a.imageElement),o(a,!0)):a.imageElement=e.document.createElement("img"),CKEDITOR.tools.trim(a.getValueOf("info","txtUrl"))||(a.preview.removeAttribute("src"),a.preview.setStyle("display","none"))},onOk:function(){var e=this;if(e.imageEditMode){var f=e.imageEditMode;b=="image"&&f=="input"&&confirm(a.lang.image.button2Img)?(f="img",e.imageElement=a.document.createElement("img"),e.imageElement.setAttribute("alt",""),a.insertElement(e.imageElement)):b!="image"&&f=="img"&&confirm(a.lang.image.img2Button)?(f="input",e.imageElement=a.document.createElement("input"),e.imageElement.setAttributes({type:"image",alt:""}),a.insertElement(e.imageElement)):(e.imageElement=e.cleanImageElement,delete e.cleanImageElement)}else b=="image"?e.imageElement=a.document.createElement("img"):(e.imageElement=a.document.createElement("input"),e.imageElement.setAttribute("type","image")),e.imageElement.setAttribute("alt","");e.linkEditMode||(e.linkElement=a.document.createElement("a")),e.commitContent(c,e.imageElement),e.commitContent(d,e.linkElement),e.imageElement.getAttribute("style")||e.imageElement.removeAttribute("style"),e.imageEditMode?!e.linkEditMode&&e.addLink?(a.insertElement(e.linkElement),e.imageElement.appendTo(e.linkElement)):e.linkEditMode&&!e.addLink&&(a.getSelection().selectElement(e.linkElement),a.insertElement(e.imageElement)):e.addLink?e.linkEditMode?a.insertElement(e.imageElement):(a.insertElement(e.linkElement),e.linkElement.append(e.imageElement,!1)):a.insertElement(e.imageElement)},onLoad:function(){var a=this;b!="image"&&a.hidePage("Link");var c=a._.element.getDocument();a.addFocusable(c.getById(w),5),a.addFocusable(c.getById(v),5),a.commitContent=l},onHide:function(){var a=this;a.preview&&a.commitContent(f,a.preview),a.originalElement&&(a.originalElement.removeListener("load",s),a.originalElement.removeListener("error",t),a.originalElement.removeListener("abort",t),a.originalElement.remove(),a.originalElement=!1),delete a.imageElement},contents:[{id:"info",label:a.lang.image.infoTab,accessKey:"I",elements:[{type:"vbox",padding:0,children:[{type:"hbox",widths:["280px","110px"],align:"right",children:[{id:"txtUrl",type:"text",label:a.lang.common.url,required:!0,onChange:function(){var a=this.getDialog(),b=this.getValue();if(b.length>0){a=this.getDialog();var c=a.originalElement;a.preview.removeStyle("display"),c.setCustomData("isReady","false");var d=CKEDITOR.document.getById(x);d&&d.setStyle("display",""),c.on("load",s,a),c.on("error",t,a),c.on("abort",t,a),c.setAttribute("src",b),r.setAttribute("src",b),a.preview.setAttribute("src",r.$.src),k(a)}else a.preview&&(a.preview.removeAttribute("src"),a.preview.setStyle("display","none"))},setup:function(a,b){if(a==c){var d=b.data("cke-saved-src")||b.getAttribute("src"),e=this;this.getDialog().dontResetSize=!0,e.setValue(d),e.setInitValue()}},commit:function(a,b){var d=this;a==c&&(d.getValue()||d.isChanged())?(b.data("cke-saved-src",d.getValue()),b.setAttribute("src",d.getValue())):a==f&&(b.setAttribute("src",""),b.removeAttribute("src"))},validate:CKEDITOR.dialog.validate.notEmpty(a.lang.image.urlMissing)},{type:"button",id:"browse",style:"display:inline-block;margin-top:10px;",align:"center",label:a.lang.common.browseServer,hidden:!0,filebrowser:"info:txtUrl"}]}]},{id:"txtAlt",type:"text",label:a.lang.image.alt,accessKey:"T","default":"",onChange:function(){k(this.getDialog())},setup:function(a,b){a==c&&this.setValue(b.getAttribute("alt"))},commit:function(a,b){var d=this;a==c?(d.getValue()||d.isChanged())&&b.setAttribute("alt",d.getValue()):a==e?b.setAttribute("alt",d.getValue()):a==f&&b.removeAttribute("alt")}},{type:"hbox",children:[{type:"vbox",children:[{type:"hbox",widths:["50%","50%"],children:[{type:"vbox",padding:1,children:[{type:"text",width:"40px",id:"txtWidth",label:a.lang.common.width,onKeyUp:j,onChange:function(){n.call(this,"advanced:txtdlgGenStyle")},validate:function(){var b=this.getValue().match(h);return b||alert(a.lang.common.invalidWidth),!!b},setup:q,commit:function(a,b,d){var h=this.getValue();if(a==c)h?b.setStyle("width",CKEDITOR.tools.cssLength(h)):!h&&this.isChanged()&&b.removeStyle("width"),!d&&b.removeAttribute("width");else if(a==e){var i=h.match(g);if(!i){var j=this.getDialog().originalElement;j.getCustomData("isReady")=="true"&&b.setStyle("width",j.$.width+"px")}else b.setStyle("width",CKEDITOR.tools.cssLength(h))}else a==f&&(b.removeAttribute("width"),b.removeStyle("width"))}},{type:"text",id:"txtHeight",width:"40px",label:a.lang.common.height,onKeyUp:j,onChange:function(){n.call(this,"advanced:txtdlgGenStyle")},validate:function(){var b=this.getValue().match(h);return b||alert(a.lang.common.invalidHeight),!!b},setup:q,commit:function(a,b,d){var h=this.getValue();if(a==c)h?b.setStyle("height",CKEDITOR.tools.cssLength(h)):!h&&this.isChanged()&&b.removeStyle("height"),!d&&a==c&&b.removeAttribute("height");else if(a==e){var i=h.match(g);if(!i){var j=this.getDialog().originalElement;j.getCustomData("isReady")=="true"&&b.setStyle("height",j.$.height+"px")}else b.setStyle("height",CKEDITOR.tools.cssLength(h))}else a==f&&(b.removeAttribute("height"),b.removeStyle("height"))}}]},{type:"html",style:"margin-top:30px;width:40px;height:40px;",onLoad:function(){var a=CKEDITOR.document.getById(w),b=CKEDITOR.document.getById(v);a&&(a.on("click",function(a){p(this),a.data.preventDefault()},this.getDialog()),a.on("mouseover",function(){this.addClass("cke_btn_over")},a),a.on("mouseout",function(){this.removeClass("cke_btn_over")},a)),b&&(b.on("click",function(a){var b=this,c=o(b),d=b.originalElement,e=b.getValueOf("info","txtWidth");if(d.getCustomData("isReady")=="true"&&e){var f=d.$.height/d.$.width*e;isNaN(f)||(b.setValueOf("info","txtHeight",Math.round(f)),k(b))}a.data.preventDefault()},this.getDialog()),b.on("mouseover",function(){this.addClass("cke_btn_over")},b),b.on("mouseout",function(){this.removeClass("cke_btn_over")},b))},html:'<div><a href="javascript:void(0)" tabindex="-1" title="'+a.lang.image.unlockRatio+'" class="cke_btn_locked" id="'+v+'" role="button"><span class="cke_label">'+a.lang.image.unlockRatio+"</span></a>"+'<a href="javascript:void(0)" tabindex="-1" title="'+a.lang.image.resetSize+'" class="cke_btn_reset" id="'+w+'" role="button"><span class="cke_label">'+a.lang.image.resetSize+"</span></a>"+"</div>"}]},{type:"vbox",padding:1,children:[{type:"text",id:"txtBorder",width:"60px",label:a.lang.image.border,"default":"",onKeyUp:function(){k(this.getDialog())},onChange:function(){n.call(this,"advanced:txtdlgGenStyle")},validate:CKEDITOR.dialog.validate.integer(a.lang.image.validateBorder),setup:function(a,b){if(a==c){var d,e=b.getStyle("border-width");e=e&&e.match(/^(\d+px)(?: \1 \1 \1)?$/),d=e&&parseInt(e[1],10),isNaN(parseInt(d,10))&&(d=b.getAttribute("border")),this.setValue(d)}},commit:function(a,b,d){var g=parseInt(this.getValue(),10);a==c||a==e?(isNaN(g)?!g&&this.isChanged()&&(b.removeStyle("border-width"),b.removeStyle("border-style"),b.removeStyle("border-color")):(b.setStyle("border-width",CKEDITOR.tools.cssLength(g)),b.setStyle("border-style","solid")),!d&&a==c&&b.removeAttribute("border")):a==f&&(b.removeAttribute("border"),b.removeStyle("border-width"),b.removeStyle("border-style"),b.removeStyle("border-color"))}},{type:"text",id:"txtHSpace",width:"60px",label:a.lang.image.hSpace,"default":"",onKeyUp:function(){k(this.getDialog())},onChange:function(){n.call(this,"advanced:txtdlgGenStyle")},validate:CKEDITOR.dialog.validate.integer(a.lang.image.validateHSpace),setup:function(a,b){if(a==c){var d,e,f,g=b.getStyle("margin-left"),h=b.getStyle("margin-right");g=g&&g.match(i),h=h&&h.match(i),e=parseInt(g,10),f=parseInt(h,10),d=e==f&&e,isNaN(parseInt(d,10))&&(d=b.getAttribute("hspace")),this.setValue(d)}},commit:function(a,b,d){var g=parseInt(this.getValue(),10);a==c||a==e?(isNaN(g)?!g&&this.isChanged()&&(b.removeStyle("margin-left"),b.removeStyle("margin-right")):(b.setStyle("margin-left",CKEDITOR.tools.cssLength(g)),b.setStyle("margin-right",CKEDITOR.tools.cssLength(g))),!d&&a==c&&b.removeAttribute("hspace")):a==f&&(b.removeAttribute("hspace"),b.removeStyle("margin-left"),b.removeStyle("margin-right"))}},{type:"text",id:"txtVSpace",width:"60px",label:a.lang.image.vSpace,"default":"",onKeyUp:function(){k(this.getDialog())},onChange:function(){n.call(this,"advanced:txtdlgGenStyle")},validate:CKEDITOR.dialog.validate.integer(a.lang.image.validateVSpace),setup:function(a,b){if(a==c){var d,e,f,g=b.getStyle("margin-top"),h=b.getStyle("margin-bottom");g=g&&g.match(i),h=h&&h.match(i),e=parseInt(g,10),f=parseInt(h,10),d=e==f&&e,isNaN(parseInt(d,10))&&(d=b.getAttribute("vspace")),this.setValue(d)}},commit:function(a,b,d){var g=parseInt(this.getValue(),10);a==c||a==e?(isNaN(g)?!g&&this.isChanged()&&(b.removeStyle("margin-top"),b.removeStyle("margin-bottom")):(b.setStyle("margin-top",CKEDITOR.tools.cssLength(g)),b.setStyle("margin-bottom",CKEDITOR.tools.cssLength(g))),!d&&a==c&&b.removeAttribute("vspace")):a==f&&(b.removeAttribute("vspace"),b.removeStyle("margin-top"),b.removeStyle("margin-bottom"))}},{id:"cmbAlign",type:"select",widths:["35%","65%"],style:"width:90px",label:a.lang.common.align,"default":"",items:[[a.lang.common.notSet,""],[a.lang.common.alignLeft,"left"],[a.lang.common.alignRight,"right"]],onChange:function(){k(this.getDialog()),n.call(this,"advanced:txtdlgGenStyle")},setup:function(a,b){if(a==c){var d=b.getStyle("float");switch(d){case"inherit":case"none":d=""}!d&&(d=(b.getAttribute("align")||"").toLowerCase()),this.setValue(d)}},commit:function(a,b,d){var g=this.getValue();if(a==c||a==e){g?b.setStyle("float",g):b.removeStyle("float");if(!d&&a==c){g=(b.getAttribute("align")||"").toLowerCase();switch(g){case"left":case"right":b.removeAttribute("align")}}}else a==f&&b.removeStyle("float")}}]}]},{type:"vbox",height:"250px",children:[{type:"html",style:"width:95%;",html:"<div>"+CKEDITOR.tools.htmlEncode(a.lang.common.preview)+"<br>"+'<div id="'+x+'" class="ImagePreviewLoader" style="display:none"><div class="loading">&nbsp;</div></div>'+'<div id="'+y+'" class="ImagePreviewBox"><table><tr><td>'+'<a href="javascript:void(0)" target="_blank" onclick="return false;" id="'+z+'">'+'<img id="'+A+'" alt="" /></a>'+(a.config.image_previewText||"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas feugiat consequat diam. Maecenas metus. Vivamus diam purus, cursus a, commodo non, facilisis vitae, nulla. Aenean dictum lacinia tortor. Nunc iaculis, nibh non iaculis aliquam, orci felis euismod neque, sed ornare massa mauris sed velit. Nulla pretium mi et risus. Fusce mi pede, tempor id, cursus ac, ullamcorper nec, enim. Sed tortor. Curabitur molestie. Duis velit augue, condimentum at, ultrices a, luctus ut, orci. Donec pellentesque egestas eros. Integer cursus, augue in cursus faucibus, eros pede bibendum sem, in tempus tellus justo quis ligula. Etiam eget tortor. Vestibulum rutrum, est ut placerat elementum, lectus nisl aliquam velit, tempor aliquam eros nunc nonummy metus. In eros metus, gravida a, gravida sed, lobortis id, turpis. Ut ultrices, ipsum at venenatis fringilla, sem nulla lacinia tellus, eget aliquet turpis mauris non enim. Nam turpis. Suspendisse lacinia. Curabitur ac tortor ut ipsum egestas elementum. Nunc imperdiet gravida mauris.")+"</td></tr></table></div></div>"}]}]}]},{id:"Link",label:a.lang.link.title,padding:0,elements:[{id:"txtUrl",type:"text",label:a.lang.common.url,style:"width: 100%","default":"",setup:function(a,b){if(a==d){var c=b.data("cke-saved-href");c||(c=b.getAttribute("href")),this.setValue(c)}},commit:function(b,c){var e=this;if(b==d)if(e.getValue()||e.isChanged()){var f=decodeURI(e.getValue());c.data("cke-saved-href",f),c.setAttribute("href",f);if(e.getValue()||!a.config.image_removeLinkByEmptyURL)e.getDialog().addLink=!0}}},{type:"button",id:"browse",filebrowser:{action:"Browse",target:"Link:txtUrl",url:a.config.filebrowserImageBrowseLinkUrl},style:"float:right",hidden:!0,label:a.lang.common.browseServer},{id:"cmbTarget",type:"select",label:a.lang.common.target,"default":"",items:[[a.lang.common.notSet,""],[a.lang.common.targetNew,"_blank"],[a.lang.common.targetTop,"_top"],[a.lang.common.targetSelf,"_self"],[a.lang.common.targetParent,"_parent"]],setup:function(a,b){a==d&&this.setValue(b.getAttribute("target")||"")},commit:function(a,b){a==d&&(this.getValue()||this.isChanged())&&b.setAttribute("target",this.getValue())}}]},{id:"Upload",hidden:!0,filebrowser:"uploadButton",label:a.lang.image.upload,elements:[{type:"file",id:"upload",label:a.lang.image.btnUpload,style:"height:40px",size:38},{type:"fileButton",id:"uploadButton",filebrowser:"info:txtUrl",label:a.lang.image.btnUpload,"for":["Upload","upload"]}]},{id:"advanced",label:a.lang.common.advancedTab,elements:[{type:"hbox",widths:["50%","25%","25%"],children:[{type:"text",id:"linkId",label:a.lang.common.id,setup:function(a,b){a==c&&this.setValue(b.getAttribute("id"))},commit:function(a,b){a==c&&(this.getValue()||this.isChanged())&&b.setAttribute("id",this.getValue())}},{id:"cmbLangDir",type:"select",style:"width : 100px;",label:a.lang.common.langDir,"default":"",items:[[a.lang.common.notSet,""],[a.lang.common.langDirLtr,"ltr"],[a.lang.common.langDirRtl,"rtl"]],setup:function(a,b){a==c&&this.setValue(b.getAttribute("dir"))},commit:function(a,b){a==c&&(this.getValue()||this.isChanged())&&b.setAttribute("dir",this.getValue())}},{type:"text",id:"txtLangCode",label:a.lang.common.langCode,"default":"",setup:function(a,b){a==c&&this.setValue(b.getAttribute("lang"))},commit:function(a,b){a==c&&(this.getValue()||this.isChanged())&&b.setAttribute("lang",this.getValue())}}]},{type:"text",id:"txtGenLongDescr",label:a.lang.common.longDescr,setup:function(a,b){a==c&&this.setValue(b.getAttribute("longDesc"))},commit:function(a,b){a==c&&(this.getValue()||this.isChanged())&&b.setAttribute("longDesc",this.getValue())}},{type:"hbox",widths:["50%","50%"],children:[{type:"text",id:"txtGenClass",label:a.lang.common.cssClass,"default":"",setup:function(a,b){a==c&&this.setValue(b.getAttribute("class"))},commit:function(a,b){a==c&&(this.getValue()||this.isChanged())&&b.setAttribute("class",this.getValue())}},{type:"text",id:"txtGenTitle",label:a.lang.common.advisoryTitle,"default":"",onChange:function(){k(this.getDialog())},setup:function(a,b){a==c&&this.setValue(b.getAttribute("title"))},commit:function(a,b){var d=this;a==c?(d.getValue()||d.isChanged())&&b.setAttribute("title",d.getValue()):a==e?b.setAttribute("title",d.getValue()):a==f&&b.removeAttribute("title")}}]},{type:"text",id:"txtdlgGenStyle",label:a.lang.common.cssStyle,"default":"",setup:function(a,b){if(a==c){var d=b.getAttribute("style");!d&&b.$.style.cssText&&(d=b.$.style.cssText),this.setValue(d);var e=b.$.style.height,f=b.$.style.width,h=(e?e:"").match(g),i=(f?f:"").match(g);this.attributesInStyle={height:!!h,width:!!i}}},onChange:function(){n.call(this,["info:cmbFloat","info:cmbAlign","info:txtVSpace","info:txtHSpace","info:txtBorder","info:txtWidth","info:txtHeight"]),k(this)},commit:function(a,b){a==c&&(this.getValue()||this.isChanged())&&b.setAttribute("style",this.getValue())}}]}]}};CKEDITOR.dialog.add("image",function(b){return a(b,"image")}),CKEDITOR.dialog.add("imagebutton",function(b){return a(b,"imagebutton")})})()