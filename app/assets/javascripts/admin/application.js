// vim: sw=4:ts=4:nu:nospell:fdc=4
/**
* An Application
*
* @author    Denis Soloshenko
* @version   $Id$
*
* @license application.js is licensed under the terms of the Open Source
* LGPL 3.0 license. Commercial use is permitted to the extent that the
* code/component(s) do NOT become part of another Open Source or Commercially
* licensed development library or toolkit without explicit permission.
*
* License details: http://www.gnu.org/licenses/lgpl.html
*/

/*global Ext, Application */

Ext.BLANK_IMAGE_URL = '/source/extjs/resources/images/default/s.gif';
Ext.ns('Application');

//application main entry point
Application.base = function(){
   Ext.QuickTips.init();

   // Далее мы определяем разные функции и объекты, которые будут
   // использованы напрямую или косвенно во Viewport
   // ...

   return {
       init: function(){
           new Ext.Viewport({
             layout: 'border'
             ,items: [
              // create instance immediately
              new Ext.BoxComponent({
                  region: 'north'
                  ,height: 32 // give north and south regions a height
                  ,autoEl: {
                      tag: 'div'
                      ,html:'<p>Административная секция</p>'
                  }
              })
              ,{
                  region: 'west'
                  ,id: 'west-panel' // see Ext.getCmp() below
                  ,title: 'Меню'
                  ,split: true
                  ,width: 200
                  ,minSize: 175
                  ,maxSize: 400
                  ,collapsible: true
                  ,margins: '0 0 0 5'
                  ,layout: {
                      type: 'fit'
                  }
                 ,items: [{xtype: 'applicationmenu'}]
              }
              // in this instance the TabPanel is not wrapped by another panel
              // since no title is needed, this Panel is added directly
              // as a Container
              ,new Ext.TabPanel({
                  id: 'main-panel-tab'
                  ,region: 'center' // a center region is ALWAYS required for border layout
                  ,deferredRender: false
                  ,activeTab: 0     // first tab initially active
                  ,items: [{
                      id: 'main-panel-tab-content'
                      ,contentEl: 'center2'
                      ,title: 'Главная панель'
                      ,autoScroll: true
                  }]
              })]
             /* конфигурация рабочей области, подключение модулей */
           });
       }
   };
}();
Ext.onReady(Application.base.init, Application.base); 

// eof