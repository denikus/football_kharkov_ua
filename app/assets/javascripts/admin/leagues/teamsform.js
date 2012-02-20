Ext.namespace("LeagueTeamsForm");
LeagueTeamsForm = Ext.extend(Ext.FormPanel, {
  initComponent: function() {
    var config = {
      labelWidth: 75,
      //url:'/admin/league/teams',
      //method: 'post',
      frame: true,
      title: 'Команды, участвующие в Лигах',
      bodyStyle:'padding:5px 5px 0',
      width: 750,
      //defaults: {width: 230},
      defaultType: 'textfield',
      items: [
        new Ext.form.ComboBox({
          fieldLabel: 'Турнир',
          hiddenName: 'tournament_id',
          displayField:'name',
          valueField: 'url',
          name: 'tournament_combo',
          typeAhead: false,
          mode: 'local',
          forceSelection: true,
          triggerAction: 'all',
          emptyText: 'Выбрать турнир...',
          selectOnFocus:true,
          width: 206,
          allowBlank:false,
          store: new Ext.data.JsonStore({
            id:'url',
            method: 'get',
            restful: true,
            root: 'rows',
            autoLoad: true,
            url:'/admin/tournaments/',
            fields:[
              {name:'url'},
              {name:'name'}
            ]
          }),
          listeners: {
            'select': function(e){
              var form = Ext.getCmp('main-panel-tab-content').items.first();
              var season_combo = form.items.get(1);
              for(var i=1; i<4; i++){
                form.items.get(i).clearValue();
                form.items.get(i).disable();
              }
              season_combo.enable();
              season_combo.store.proxy = new Ext.data.HttpProxy({
                url: '/admin/tournaments/' + this.value + '/seasons'
              });
              season_combo.store.reload();
            }
          }
        }),
        new Ext.form.ComboBox({
          fieldLabel: 'Сезон',
          hiddenName: 'season_id',
          displayField: 'name',
          valueField: 'id',
          name: 'season_combo',
          typeAhead: false,
          mode: 'local',
          forceSelection: true,
          triggerAction: 'all',
          emptyText: 'Выбрать сезон...',
          selectOnFocus:true,
          width: 206,
          disabled: true,
          allowBlank:false,
          store: new Ext.data.JsonStore({
            id:'id',
            method: 'get',
            restful: true,
            root: 'rows',
            fields:[
              {name:'id'},
              {name:'name'}
            ]
          }),
          listeners: {
            'select': function(e){
              var form = Ext.getCmp('main-panel-tab-content').items.first();
              var stage_combo = form.items.get(2);
              for(var i=2; i<4; i++){
                form.items.get(i).clearValue();
                form.items.get(i).disable();
              }
              stage_combo.enable();
              stage_combo.store.proxy = new Ext.data.HttpProxy({
                url: '/admin/seasons/' + this.value + '/stages'
              });
              stage_combo.store.reload();
            }
          }
        }),
        new Ext.form.ComboBox({
          fieldLabel: 'Этап',
          hiddenName: 'stage_id',
          displayField: 'name',
          valueField: 'id',
          name: 'stage_combo',
          typeAhead: false,
          mode: 'local',
          forceSelection: true,
          triggerAction: 'all',
          emptyText: 'Выбрать этап...',
          selectOnFocus:true,
          width: 206,
          disabled: true,
          allowBlank:false,
          store: new Ext.data.JsonStore({
            id:'id',
            method: 'get',
            restful: true,
            root: 'rows',
            fields:[
              {name:'id'},
              {name:'name'}
            ]
          }),
          listeners: {
            'select': function(e){
              var form = Ext.getCmp('main-panel-tab-content').items.first();
              var league_combo = form.items.get(3);
              league_combo.enable();
              league_combo.clearValue();
              league_combo.store.proxy = new Ext.data.HttpProxy({
                url: '/admin/stages/' + this.value + '/leagues'
              });
              league_combo.store.reload();
            }
          }
        }),
        new Ext.form.ComboBox({
          fieldLabel: 'Лига',
          hiddenName: 'league_id',
          displayField:'name',
          valueField: 'id',
          name: 'league_combo',
          typeAhead: false,
          mode: 'local',
          forceSelection: true,
          triggerAction: 'all',
          emptyText: 'Выбрать лигу...',
          selectOnFocus:true,
          width: 206,
          disabled: true,
          allowBlank:false,
          store: new Ext.data.JsonStore({
            id:'id',
            method: 'get',
            restful: true,
            root: 'rows',
            fields:[
              {name:'id'},
              {name:'name'}
            ]
          }),
          listeners: {
            'select': function(e){
              var form = Ext.getCmp('main-panel-tab-content').items.first();
              var team_selector = form.items.get(4);
              team_selector.enable();
              team_selector.multiselects[1].store.proxy = new Ext.data.HttpProxy({
                url: '/admin/leagues/' + this.value + '/teams'
              });
              team_selector.multiselects[1].store.reload();
            }
          }
        }),
        {
          xtype: 'itemselector',
          name: 'team_ids',
          //disabled: true,
          fieldLabel: 'Выбрать Команды',
          imagePath: '/source/extjs/examples/ux/images/',
          multiselects: [{
            width: 250,
            height: 200,
            store: new Ext.data.JsonStore({
              id:'id',
              method: 'get',
              restful: true,
              root: 'rows',
              autoLoad: false,
              proxy: new Ext.data.HttpProxy({
                url: '/admin/teams'
              }),
              fields:[
                {name:'id'},
                {name:'name'}
              ],
              listeners: {
                'load': function(store, records){
                  var form = Ext.getCmp('main-panel-tab-content').items.first();
                  var selected_store = form.items.get(4).multiselects[1].store;
                  selected_record_ids = [];
                  selected_store.each(function(r){ selected_record_ids.push(r.id) });
                  this.filterBy(function(r){ return selected_record_ids.indexOf(r.id) == -1 });
                }
              }
            }),
            displayField: 'name',
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
                {name:'id'},
                {name:'name'}
              ],
              listeners: {
                'load': function(store, records){
                  var form = Ext.getCmp('main-panel-tab-content').items.first();
                  var team_selector = form.items.get(4);
                  team_selector.multiselects[0].store.reload();
                }
              }
            }),
            displayField: 'name',
            valueField: 'id'
          }]
        }
      ],
      
      buttons: [{
        text: 'Save',
        handler: function(){
          var form = Ext.getCmp('main-panel-tab-content').items.first();
          var league_combo = form.items.get(3);
          form.getForm().submit({
            url: '/admin/leagues/' + league_combo.value + '.json',
            method: 'PUT',
            waitMsg: 'Saving Data...',
            success: function(form, action) {
              Ext.Msg.alert('Статус', 'Данные успешно сохранены');
            }
          });
        }
      }]
    }
    
    Ext.apply(this, config);
    
    LeagueTeamsForm.superclass.initComponent.apply(this, arguments);
  }
});

Ext.reg("leagueteamsform", LeagueTeamsForm);