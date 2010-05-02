Ext.namespace("SeasonGrid");
SeasonGrid = Ext.extend(Ext.grid.GridPanel, {
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
                 ,url:'/admin/seasons'
                 ,fields:[
                    {name:'id'}
                   ,{name:'name'}
                   ,{name:'url'}
                 ]
              })
              ,columns:[{
                 id:'id'
                 ,header:"ID"
                 ,width:10, sortable:true
                 ,dataIndex:'id'
                 },{
                 header:"Название"
                 ,width:30
                 ,sortable:true
                 ,dataIndex:'name'
                 },{
                 header:"Url"
                 ,width:30
                 ,sortable:true
                 ,dataIndex:'url'
                 }]
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
          SeasonGrid.superclass.initComponent.apply(this, arguments);

         // load the store at the latest possible moment
         this.on({
         afterlayout:{scope:this, single:true, fn:function() {
           this.store.load({params:{start:0, limit:ROWS_PER_PAGE}});
         }}
         });
      }
      , onDestroy: function(){
          this.somewindow.destroy();
          SeasonGrid.superclass.onDestroy.call(this);
      }
      , entityAdd: function(button, e) {
         var season_dialog = new SeasonDialog();
         season_dialog.show();
      }
      , entityRemove: function(button, e){/* Код удаления сущности */}
      , entityEdit: function(button, e){/* Код редактирования сущности */}
      , somewindow: undefined
 });
 Ext.reg("seasongrid", SeasonGrid);
