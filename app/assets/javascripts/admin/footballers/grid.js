Ext.namespace("FootballerGrid");
FootballerGrid = Ext.extend(Ext.grid.GridPanel, {
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
                 ,url:'/admin/footballers'
                 ,fields:[
                    {name:'id'}
                   ,{name:'first_name'}
                   ,{name:'last_name'}
                   ,{name:'patronymic'}
                 ]
              })
              ,columns:[{
                 id:'id'
                 ,header:"ID"
                 ,width:10, sortable:true
                 ,dataIndex:'id'
                 }
                ,{
                   header:"Имя"
                   ,width:30
                   ,sortable:true
                   ,dataIndex:'first_name'
                 }
                ,{
                   header:"Фамилия"
                   ,width:30
                   ,sortable:true
                   ,dataIndex:'last_name'
                 }
                ,{
                   header:"Отчество"
                   ,width:30
                   ,sortable:true
                   ,dataIndex:'patronymic'
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
          FootballerGrid.superclass.initComponent.apply(this, arguments);

         // load the store at the latest possible moment
         this.on({
         afterlayout:{scope:this, single:true, fn:function() {
           this.store.load({params:{start:0, limit:ROWS_PER_PAGE}});
         }}
         });
      }
      , onDestroy: function(){
          this.somewindow.destroy();
          FootballerGrid.superclass.onDestroy.call(this);
      }
      , entityAdd: function(button, e) {
         var footballer_dialog = new FootballerDialog();
         footballer_dialog.show();
      }
      , entityRemove: function(button, e){/* Код удаления сущности */}
      , entityEdit: function(button, e){/* Код редактирования сущности */}
      , somewindow: undefined
 });
 Ext.reg("footballergrid", FootballerGrid);
