/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
CKEDITOR.dialog.add("hiddenfield",function(a){return{title:a.lang.hidden.title,hiddenField:null,minWidth:350,minHeight:110,onShow:function(){var a=this;delete a.hiddenField;var b=a.getParentEditor(),c=b.getSelection(),d=c.getSelectedElement();d&&d.data("cke-real-element-type")&&d.data("cke-real-element-type")=="hiddenfield"&&(a.hiddenField=d,d=b.restoreRealElement(a.hiddenField),a.setupContent(d),c.selectElement(a.hiddenField))},onOk:function(){var a=this,b=a.getValueOf("info","_cke_saved_name"),c=a.getValueOf("info","value"),d=a.getParentEditor(),e=CKEDITOR.env.ie?d.document.createElement('<input name="'+CKEDITOR.tools.htmlEncode(b)+'">'):d.document.createElement("input");e.setAttribute("type","hidden"),a.commitContent(e);var f=d.createFakeElement(e,"cke_hidden","hiddenfield");return a.hiddenField?(f.replace(a.hiddenField),d.getSelection().selectElement(f)):d.insertElement(f),!0},contents:[{id:"info",label:a.lang.hidden.title,title:a.lang.hidden.title,elements:[{id:"_cke_saved_name",type:"text",label:a.lang.hidden.name,"default":"",accessKey:"N",setup:function(a){this.setValue(a.data("cke-saved-name")||a.getAttribute("name")||"")},commit:function(a){this.getValue()?a.setAttribute("name",this.getValue()):a.removeAttribute("name")}},{id:"value",type:"text",label:a.lang.hidden.value,"default":"",accessKey:"V",setup:function(a){this.setValue(a.getAttribute("value")||"")},commit:function(a){this.getValue()?a.setAttribute("value",this.getValue()):a.removeAttribute("value")}}]}]}})