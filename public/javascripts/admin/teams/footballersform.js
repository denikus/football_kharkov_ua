Ext.namespace("TeamFootballersForm");
TeamFootballersForm = Ext.extend(Ext.FormPanel, {
  initComponent: function() {
    var config = {
      labelWidth: 75,
      frame: true,
      title: 'Футболисты, играющие в командах',
      bodyStyle:'padding: 5px 5px 0',
      width: 750,
      defaultType: 'textfield',
      items: [
        new Ext.form.ComboBox({
          fieldLabel: 'Команда',
          hiddenName: 'team_id',
          displayField: 'name',
          valueField: 'id',
          name: 'team_combo',
          typeAhead: false,
          mode: 'local',
          forceSelection: true,
          triggerAction: 'all',
          emptyText: 'Выбрать команду...',
          selectOnFocus:true,
          width: 206,
          allowBlank:false,
          store: new Ext.data.JsonStore({
            id: 'id',
            method: 'get',
            restful: true,
            root: 'rows',
            autoLoad: true,
            url: '/admin/teams/',
            fields:[
              {name:'id'},
              {name:'name'}
            ]
          }),
          listeners: {
            'select': function(e){
              var form = Ext.getCmp('main-panel-tab-content').items.first();
              var team_selector = form.items.get(1);
              team_selector.enable();
              team_selector.multiselects[1].store.proxy = new Ext.data.HttpProxy({
                url: '/admin/teams/' + this.value + '/footballers'
              });
              team_selector.multiselects[1].store.reload();
            }
          }
        }),
        {
          xtype: 'itemselector',
          name: 'footballer_ids',
          //disabled: true,
          fieldLabel: 'Выбрать Футболистов',
          imagePath: '/source/extjs/examples/ux/images/',
          multiselects: [{
            width: 250,
            height: 200,
            store: new Ext.data.JsonStore({
              id: 'id',
              method: 'get',
              restful: true,
              root: 'rows',
              autoLoad: false,
              proxy: new Ext.data.HttpProxy({
                url: '/admin/footballers'
              }),
              fields:[
                {name: 'id'},
                {name: 'full_name'}
              ],
              listeners: {
                'load': function(store, records){
                  var form = Ext.getCmp('main-panel-tab-content').items.first();
                  var selected_store = form.items.get(1).multiselects[1].store;
                  selected_record_ids = [];
                  selected_store.each(function(r){ selected_record_ids.push(r.id) });
                  this.filterBy(function(r){ return selected_record_ids.indexOf(r.id) == -1 });
                }
              }
            }),
            displayField: 'full_name',
            valueField: 'id'
          },{
            width: 250,
            height: 200,
            store: new Ext.data.JsonStore({
              id:'id',
              method: 'get',
              restful: true,
              root: 'rows',
              autoLoad: false,
              fields:[
                {name: 'id'},
                {name: 'full_name'}
              ],
              listeners: {
                'load': function(store, records){
                  var form = Ext.getCmp('main-panel-tab-content').items.first();
                  var team_selector = form.items.get(1);
                  team_selector.multiselects[0].store.reload();
                }
              }
            }),
            displayField: 'full_name',
            valueField: 'id'
          }]
        }
      ],
      
      buttons: [{
        text: 'Save',
        handler: function(){
          var form = Ext.getCmp('main-panel-tab-content').items.first();
          var teams_combo = form.items.first();
          form.getForm().submit({
            url: '/admin/teams/' + teams_combo.value + '.json',
            method: 'PUT',
            waitMsg: 'Сохраняем...',
            success: function(form, action) {
              Ext.Msg.alert('Статус', 'Данные успешно сохранены');
            }
          });
        }
      }]
    }
    
    Ext.apply(this, config);
    
    TeamFootballersForm.superclass.initComponent.apply(this, arguments);
  }
});

Ext.reg("teamfootballersform", TeamFootballersForm);