Ext.namespace("StageGrid");
StageGrid = Ext.extend(Ext.grid.GridPanel, {
       initComponent: function() {
         // Настраиваем диалоговое окно
         Ext.apply(this, {
             somewindow: new Ext.Window({/* Настройки окна */})
         });

         // Настраиваем хранилище
          Ext.apply(this, {
              store: new Ext.data.JsonStore({
                  id:'id'
                 ,totalProperty:'total_count'
                 ,root:'rows'
                 ,method: 'get'
                 ,restful: true
                 ,url:'/admin/stages'
                 ,fields:[
                    {name:'id'}
                   ,{name:'number'}
                   ,{name:'season'}
                 ]
              })
              ,columns:[{
                 id:'id'
                 ,header:"ID"
                 ,width:10, sortable:true
                 ,dataIndex:'id'
                 }
                ,{
                 header:"Номер"
                 ,width:30
                 ,sortable:true
                 ,dataIndex:'number'
                 }
                ,{
                 header:"Сезон"
                 ,width:30
                 ,sortable:true
                 ,dataIndex:'season'
                 }
                ]
               ,viewConfig:{forceFit:true}
               ,loadMask:true
               ,autoHeight:true

          });

          // Настраиваем панель инструментов
          Ext.apply(this, {
                bbar: new Ext.PagingToolbar({
                   pageSize: ROWS_PER_PAGE // [2]
                  ,store: this.store
                  ,displayInfo: true
              }),
              tbar: new Ext.Toolbar({
                 items: [{
                     text: "Добавить"
                     ,handler: this.entityAdd.createDelegate(this)
                     ,iconCls: 'add-item'
                 }]
              })
          });
          StageGrid.superclass.initComponent.apply(this, arguments);

         // load the store at the latest possible moment
         this.on({
         afterlayout:{scope:this, single:true, fn:function() {
           this.store.load({params:{start:0, limit:ROWS_PER_PAGE}});
         }}
         });
      }
      , onDestroy: function(){
          this.somewindow.destroy();
          StageGrid.superclass.onDestroy.call(this);
      }
      , entityAdd: function(button, e) {
         var stage_dialog = new StageDialog();
         stage_dialog.show();
      }
      , entityRemove: function(button, e){/* Код удаления сущности */}
      , entityEdit: function(button, e){/* Код редактирования сущности */}
      , somewindow: undefined
 });
 Ext.reg("stagegrid", StageGrid);
