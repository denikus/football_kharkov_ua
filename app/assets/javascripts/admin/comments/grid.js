Ext.namespace("CommentGrid");
CommentGrid = Ext.extend(Ext.grid.GridPanel, {
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
                 ,url:'/admin/comments'
                 // ,listeners:{loadexception:console.log}
                 ,fields:[
                 {name:'id'}
                 ,{name:'author'}
                 ,{name:'date', type:'date'}
                 ]
              })
              ,columns:[{
                 id:'id'
                 ,header:"ID"
                 ,width:40, sortable:true
                 ,dataIndex:'id'
                 },{
                 header:"Автор"
                 ,width:20
                 ,sortable:true
                 ,dataIndex:'author'
                 },{
                 header:"Дата"
                 ,width:20
                 ,sortable:true
                 ,dataIndex:'date'
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
              })
          });
          CommentGrid.superclass.initComponent.apply(this, arguments);

         // load the store at the latest possible moment
         this.on({
         afterlayout:{scope:this, single:true, fn:function() {
           this.store.load({params:{start:0, limit:ROWS_PER_PAGE}});
         }}
         });
      }
      , onDestroy: function(){
          this.somewindow.destroy();
          CommentGrid.superclass.onDestroy.call(this);
      }
      , entityRemove: function(button, e){/* Код удаления сущности */}
      , entityEdit: function(button, e){/* Код редактирования сущности */}
      , somewindow: undefined
 });
 Ext.reg("commentgrid", CommentGrid);
