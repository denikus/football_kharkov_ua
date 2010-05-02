Ext.namespace("MatchesPanel");

MatchesPanel.handlers = {
  resetSelectableFields: function(index){
    ['matches-panel-league-selection', 'matches-panel-tour-selection'].map(function(container_id){
      var items = Ext.ComponentMgr.get(container_id).items;
      var start = container_id == 'matches-panel-league-selection' ? index : 0;
      for(var i = start; i < items.length; i++) {
        if(typeof(items.get(i).clearValue) == 'function') items.get(i).clearValue();
        items.get(i).disable()
      }
    });
  },
  tournamentSelected: function(value){
    MatchesPanel.handlers.resetSelectableFields(1);
    var season_combo = Ext.ComponentMgr.get('matches-panel-season-combobox');
    season_combo.store.proxy = new Ext.data.HttpProxy({
      url: '/admin/tournaments/' + value + '/seasons'
    });
    season_combo.store.reload();
    season_combo.enable();
  },
  seasonSelected: function(value){
    MatchesPanel.handlers.resetSelectableFields(2);
    var stage_combo = Ext.ComponentMgr.get('matches-panel-stage-combobox');
    stage_combo.store.proxy = new Ext.data.HttpProxy({
      url: '/admin/seasons/' + value + '/stages'
    });
    stage_combo.store.reload();
    stage_combo.enable();
  },
  stageSelected: function(value){
    MatchesPanel.handlers.resetSelectableFields(3);
    var leagues_combo = Ext.ComponentMgr.get('matches-panel-league-combobox');
    leagues_combo.store.proxy = new Ext.data.HttpProxy({
      url: '/admin/stages/' + value + '/leagues'
    });
    leagues_combo.store.reload();
    leagues_combo.enable();
  },
  leagueSelected: function(value){
    MatchesPanel.handlers.resetSelectableFields(4);
    var tour_combo = Ext.ComponentMgr.get('matches-panel-tour-combobox');
    tour_combo.store.proxy = new Ext.data.HttpProxy({
      url: '/admin/leagues/' + value + '/tours'
    });
    tour_combo.store.reload();
    tour_combo.enable();
    Ext.ComponentMgr.get('matches-panel-tour-newbutton').enable();
  },
  tourSelected: function(value){
    var matches_grid = Ext.ComponentMgr.get('matches-panel-matches-grid');
    matches_grid.store.proxy = new Ext.data.HttpProxy({
      url: '/admin/tours/' + value + '/matches',
      method: 'get'
    });
    matches_grid.store.reload();
    matches_grid.enable();
  },
  competitorSelected: function(id, type){
    var container = Ext.ComponentMgr.get('matches-panel-new-match-competitors-'+type);
    container.removeAll();
    Ext.Ajax.request({
      url: '/admin/teams/' + id + '/footballers',
      success: function(response){
        var players = Ext.decode(response.responseText);
        players.rows.map(function(player){
          container.add({
            xtype: 'container',
            layout: 'column',
            columns: [.05,.70,.25],
            items: [
              {xtype: 'checkbox', name: 'match[competitors]['+type+'][football_players]['+player.id+'][included]', checked: true},
              {xtype: 'label', text: player.full_name},
              {xtype: 'textfield', width: '25', name: 'match[competitors]['+type+'][football_players]['+player.id+'][number]'}
            ]
          });
        });
        container.doLayout(false, true);
      }
    });
  },
  editMatch: function(match_id) {
    var dialog = new MatchesPanel.EditMatchDialog();
    dialog.setMatchId(match_id);
    dialog.show();
    return false;
  }
}

MatchesPanel.NewTourDialog = Ext.extend(Ext.Window, {
  initComponent: function() {
    Ext.apply(this, {
      form: new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 55,
        url: '/admin/tours',
        defaultType: 'textfield',
        baseParams: {format: 'ext_json'},
        items: [{
          fieldLabel: 'Название',
          name: 'tour[name]',
          anchor:'100%'
        }, {
          xtype: 'hidden',
          name: 'tour[league_id]',
          value: Ext.ComponentMgr.get('matches-panel-league-combobox').value
        }]
      }),
      saveTour: function() {
        var self = this;
        this.form.getForm().submit({
          success: function() {
            var tour_combo = Ext.ComponentMgr.get('matches-panel-tour-combobox');
            tour_combo.store.proxy = new Ext.data.HttpProxy({
              url: '/admin/leagues/' + Ext.ComponentMgr.get('matches-panel-league-combobox').value + '/tours'
            });
            tour_combo.store.reload();
            self.closeDialog();
          }
        });
      },
      closeDialog: function() {
        this.close();
      }
    });
    
    Ext.apply(this, {
      title: 'Новый Тур',
      width: 300,
      height:150,
      minWidth: 100,
      minHeight: 75,
      layout: 'fit',
      plain: true,
      bodyStyle:'padding:5px;',
      buttonAlign:'center',
      items: this.form,
      buttons: [{
        text: 'Сохранить',
        handler: this.saveTour.createDelegate(this)
      }, {
        text: 'Отмена',
        handler: this.closeDialog.createDelegate(this)
      }]
    });
    
    MatchesPanel.NewTourDialog.superclass.initComponent.apply(this, arguments);
  }
});

MatchesPanel.NewMatchDialog = Ext.extend(Ext.Window, {
  initComponent: function() {
    Ext.apply(this, {
      form: new Ext.form.FormPanel({
        url: '/admin/matches',
        frame: true,
        labelWidth: 100,
        width: 670,
        bodyStyle: 'padding:0 10px 0;',
        baseParams: {format: 'ext_json'},
        items: [
          {
            xtype: 'fieldset',
            title: 'Основные Данные',
            autoHeight: true,
            id: 'matches-panel-new-match-params',
            items: [{
                xtype: 'hidden',
                name: 'match[tour_id]',
                value: Ext.ComponentMgr.get('matches-panel-tour-combobox').value
              },
              new Ext.form.ComboBox({
                displayField: 'full_name',
                fieldLabel: 'Судья',
                hiddenName: 'match[referee_id]',
                valueField: 'id',
                typeAhead: false,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: 'Выбрать судью...',
                selectOnFocus:true,
                width: 206,
                allowBlank:false,
                store: new Ext.data.JsonStore({
                  method: 'get',
                  restful: true,
                  root: 'rows',
                  autoLoad: true,
                  url: '/admin/referees/',
                  fields:[
                    {name:'id'},
                    {name:'full_name'}
                  ]
                })
              }), new Ext.form.DateField({
                allowBlank: false,
                name: 'match[play_date]',
                format: 'Y-m-d',
                fieldLabel: 'Дата'
              }), new Ext.form.TimeField({
                name: 'match[play_time]',
                allowBlank: false,
                fieldLabel: 'Время'
              }), new Ext.form.ComboBox({
                fieldLabel: 'Тип',
                name: 'match[match_type]',
                typeAhead: false,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: 'Выбрать тип...',
                selectOnFocus:true,
                width: 206,
                allowBlank: false,
                store: [['mini', 'Мини'], ['big', 'Большой']]
              }), {
                xtype: 'textfield',
                fieldLabel: 'Длительность тайма',
                name: 'match[period_duration]',
                value: '20',
                allowBlank: false
              }
            ]
          }, {
            xtype: 'fieldset',
            title: 'Составы',
            autoHeight: true,
            items: [
              {
                layout: 'column',
                border: true,
                items: [
                  {
                    columnWidth: '.5',
                    items: [
                      {xtype: 'label', text: 'Хозяева: '},
                      new Ext.form.ComboBox({
                        id: 'matches-panel-new-match-hosts-combobox',
                        fieldLabel: 'Хозяева',
                        displayField: 'name',
                        valueField: 'id',
                        typeAhead: false,
                        hiddenName: 'match[competitors][hosts][team_id]',
                        mode: 'local',
                        forceSelection: true,
                        triggerAction: 'all',
                        emptyText: 'Выбрать команду...',
                        selectOnFocus:true,
                        width: 206,
                        allowBlank:false,
                        store: new Ext.data.JsonStore({
                          method: 'get',
                          restful: true,
                          root: 'rows',
                          autoLoad: true,
                          url: '/admin/leagues/'+Ext.ComponentMgr.get('matches-panel-league-combobox').value+'/teams',
                          fields:[
                            {name:'id'},
                            {name:'name'}
                          ]
                        }),
                        listeners: {
                          'select': function(e){
                            MatchesPanel.handlers.competitorSelected(this.value, 'hosts');
                          }
                        }
                      }), {
                        xtype: 'fieldset',
                        layout: 'column',
                        border: false,
                        title: 'Назначить состав',
                        id: 'matches-panel-new-match-competitors-hosts',
                        layout: 'column',
                        columns: [.05, .70, .25]
                      }
                    ]
                  }, {
                    columnWidth: '.5',
                    items: [
                      {xtype: 'label', text: 'Гости: '},
                      new Ext.form.ComboBox({
                        id: 'matches-panel-new-match-guests-combobox',
                        fieldLabel: 'Гости',
                        hiddenName: 'match[competitors][guests][team_id]',
                        displayField: 'name',
                        valueField: 'id',
                        typeAhead: false,
                        mode: 'local',
                        forceSelection: true,
                        triggerAction: 'all',
                        emptyText: 'Выбрать команду...',
                        selectOnFocus:true,
                        width: 206,
                        allowBlank:false,
                        store: new Ext.data.JsonStore({
                          method: 'get',
                          restful: true,
                          root: 'rows',
                          autoLoad: true,
                          url: '/admin/leagues/'+Ext.ComponentMgr.get('matches-panel-league-combobox').value+'/teams',
                          fields:[
                            {name:'id'},
                            {name:'name'}
                          ]
                        }),
                        listeners: {
                          'select': function(e){
                            MatchesPanel.handlers.competitorSelected(this.value, 'guests');
                          }
                        }
                      }), {
                        xtype: 'fieldset',
                        layout: 'column',
                        border: false,
                        title: 'Назначить состав',
                        id: 'matches-panel-new-match-competitors-guests',
                        layout: 'column',
                        columns: [.05, .70, .25]
                      }
                    ]
                  }
                ]
              }
            ]
          }, {
            xtype: 'fieldset',
            title: 'Описание',
            autoHeight: true,
            items: {
              xtype: 'textfield',
              fieldLabel: 'Описание',
              name: 'match[comment]',
              width: '500',
              height: '75'
            }
          }
        ]
      }),
      
      saveMatch: function() {
        var self = this;
        this.form.getForm().submit({
          waitMsg: 'Сохраняем матч...',
          success: function() {
            self.closeDialog();
            Ext.ComponentMgr.get('matches-panel-matches-grid').store.reload();
          }
        });
      },
      closeDialog: function() {
        this.close();
      }
    });
    
    Ext.apply(this, {
      title: 'Новый Матч',
      width: 700,
      height: 600,
      minWidth: 700,
      minHeight: 600,
      autoScroll: true,
      layout: 'fit',
      plain: true,
      bodyStyle: 'padding:5px;',
      buttonAlign: 'center',
      items: this.form,
      buttons: [{
        text: 'Сохранить',
        handler: this.saveMatch.createDelegate(this)
      }, {
        text: 'Отмена',
        handler: this.closeDialog.createDelegate(this)
      }]
    });
    
    MatchesPanel.NewMatchDialog.superclass.initComponent.apply(this, arguments);
  }
});

MatchesPanel.AddEventDialog = Ext.extend(Ext.Window, {
  initComponent: function() {
    var self = this;
    Ext.apply(this, {
      match_id: null,
      setMatchId: function(match_id){
        this.match_id = match_id;
        this.form.getForm().url = '/admin/matches/'+this.match_id+'/events'
      },
      form: new Ext.form.FormPanel({
        url: '/admin/matches/undefined/events',
        frame: true,
        labelWidth: 100,
        width: 670,
        bodyStyle: 'padding:0 10px 0;',
        baseParams: {format: 'ext_json'},
        items: [
          {
            xtype: 'fieldset',
            title: 'Основные Данные',
            autoHeight: true,
            items: [{
                xtype: 'textfield',
                fieldLabel: 'Минута',
                name: 'match_event[minute]',
                width: '20',
                allowBlank: false
              }, {
                xtype: 'textfield',
                fieldLabel: 'Сообщение',
                name: 'match_event[message]',
                width: '500',
                allowBlank: false
              }, new Ext.form.ComboBox({
                fieldLabel: 'Тип',
                hiddenName: 'match_event[event_type]',
                typeAhead: false,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: 'Выбрать тип...',
                selectOnFocus: true,
                width: 206,
                allowBlank: false,
                store: [['misc', 'Общее'], ['player', 'Статистика Игрока'], ['team', 'Командное']],
                listeners: {
                  'select': function(e) {
                    ['misc', 'player', 'team'].map(function(id){ Ext.ComponentMgr.get('matches-panel-new-match-event-' + id + '-params').collapse(); });
                    Ext.ComponentMgr.get('matches-panel-new-match-event-' + this.value + '-params').toggleCollapse(false);
                  }
                }
              })
            ]
          }, {
            xtype: 'fieldset',
            title: 'Общее',
            autoHeight: true,
            collapsed: true,
            id: 'matches-panel-new-match-event-misc-params',
            items: new Ext.form.ComboBox({
              fieldLabel: 'Тип',
              hiddenName: 'match_event[event_type_params][misc][event_type]',
              typeAhead: false,
              mode: 'local',
              forceSelection: true,
              triggerAction: 'all',
              emptyText: 'Выбрать тип...',
              selectOnFocus: true,
              width: 206,
              allowBlank: true,
              store: [['time', 'Временное'], ['moment', 'Опасный момент'], ['off_game', 'Положение вне игры'], ['misc', 'Общее']]
            })
          }, {
            xtype: 'fieldset',
            title: 'Статистика игрока',
            autoHeight: true,
            collapsed: true,
            id: 'matches-panel-new-match-event-player-params',
            items: new Ext.form.ComboBox({
              fieldLabel: 'Тип',
              hiddenName: 'match_event[event_type_params][player][event_type]',
              typeAhead: false,
              mode: 'local',
              forceSelection: true,
              triggerAction: 'all',
              emptyText: 'Выбрать тип...',
              selectOnFocus: true,
              width: 206,
              allowBlank: true,
              store: [['score', 'Гол'], ['card', 'Карточка'], ['injury', 'Травма']]
            })
          }, {
            xtype: 'fieldset',
            title: 'Командное',
            autoHeight: true,
            collapsed: true,
            id: 'matches-panel-new-match-event-team-params',
            items: []
          }
        ]
      }),
      
      saveEvent: function() {
        var self = this;
        this.form.getForm().submit({
          waitMsg: 'Сохраняем событие...',
          success: function() {
            Ext.ComponentMgr.get('matches-panel-edit-match-events-grid').store.reload();
            self.closeDialog();
          }
        });
      },
      closeDialog: function() {
        this.close();
      }
    });
    
    Ext.apply(this, {
      title: 'Новое Событие',
      width: 700,
      height: 600,
      minWidth: 700,
      minHeight: 600,
      autoScroll: true,
      layout: 'fit',
      plain: true,
      bodyStyle: 'padding:5px;',
      buttonAlign: 'center',
      items: this.form,
      buttons: [{
        text: 'Сохранить',
        handler: this.saveEvent.createDelegate(this)
      }, {
        text: 'Отмена',
        handler: this.closeDialog.createDelegate(this)
      }]
    });
    
    this.on('render', function(){
      Ext.Ajax.request({
        url: '/admin/matches/' + self.match_id + '/competitors',
        success: function(response){
          var competitors = Ext.decode(response.responseText);
          var team_set = Ext.ComponentMgr.get('matches-panel-new-match-event-team-params');
          var player_set = Ext.ComponentMgr.get('matches-panel-new-match-event-player-params');
          competitors.map(function(c){
            team_set.add({xtype: 'radio', boxLabel: c.team_name, name: 'match_event[event_type_params][team][competitor_id]', inputValue: c.competitor_id});
            player_radios = c.footballers.map(function(fp){
              return {xtype: 'radio', boxLabel: fp.name, name: 'match_event[event_type_params][player][football_player_id]', inputValue: fp.football_player_id};
            });
            player_set.add({
              xtype: 'fieldset',
              title: c.team_name,
              autoHeight: true,
              items: player_radios
            });
          });
        }
      });
    });
    
    MatchesPanel.AddEventDialog.superclass.initComponent.apply(this, arguments);
  }
});
MatchesPanel.EditMatchDialog = Ext.extend(Ext.Window, {
  initComponent: function(){
    var self = this;
    var grid_store = new Ext.data.JsonStore({
      totalProperty: 'total_count',
      root: 'rows',
      restful: true,
      autoLoad: false,
      fields: [
        {name: 'id'},
        {name: 'period'},
        {name: 'minute'},
        {name: 'source'},
        {name: 'message'}
      ]
    });
    Ext.apply(this, {
      setMatchId: function(match_id){
        this.match_id = match_id;
        this.grid.store.proxy = new Ext.data.HttpProxy({
          url: '/admin/matches/' + this.match_id + '/events',
          method: 'get'
        });
      },
      grid: new Ext.grid.GridPanel({
        width: 600,
        autoExpandColumn: 'message',
        viewConfig: {forceFit: true},
        loadMask: true,
        autoHeight: true,
        id: 'matches-panel-edit-match-events-grid',
        store: grid_store,
        columns: [{
          header: 'Тайм',
          width: 10,
          sortable: true,
          dataIndex: 'period'
        }, {
          header: 'Минута',
          width: 10,
          sortable: true,
          dataIndex: 'minute'
        }, {
          header: 'Команда/игрок',
          width: 100,
          sortable: false,
          dataIndex: 'source'
        }, {
          header: 'Сообщение',
          width: 400,
          sortable: false,
          dataIndex: 'message'
        }],
        tbar: [{
          iconCls: 'add-item',
          text: 'Добавить Событие',
          handler: function(){
            dialog = new MatchesPanel.AddEventDialog();
            dialog.setMatchId(self.match_id);
            dialog.show();
          }
        }, {
          iconCls: 'del-item',
          text: 'Удалить Событие',
          handler: function (){
            var grid = Ext.ComponentMgr.get('matches-panel-edit-match-events-grid');
            var match_id = grid.getSelectionModel().getSelected().json.match_id;
            var event_id = grid.getSelectionModel().getSelected().json.id;
            Ext.Ajax.request({
              url: '/admin/matches/'+match_id+'/events/'+event_id,
              method: 'DELETE',
              waitMsg: 'Удаляем событие...',
              success: function(response, options){
                grid.store.reload();
              }
            })
          }
        }],
        bbar: new Ext.PagingToolbar({
          pageSize: ROWS_PER_PAGE,
          store: grid_store,
          displayInfo: true
        })
      })
    });
    Ext.apply(this, {
      form: new Ext.FormPanel({
        labelWidth: 200,
        frame: true,
        bodyStyle: 'padding:5px 5px 0',
        width: 600,
        defaults: {width: 50},
        defaultType: 'textfield',
        items: [{
            xtype: 'spinnerfield',
            fieldLabel: 'Штрафные Хозяев',
            id: 'edit-match-hosts-fouls',
            name: 'host-fouls',
            minValue: 0,
            maxValue: 100
          }, {
            xtype: 'spinnerfield',
            fieldLabel: 'Штрафные Гостей',
            id: 'edit-match-guests-fouls',
            name: 'guest-fouls',
            minValue: 0,
            maxValue: 100
          }, {
            xtype: 'button',
            text: 'Сохранить',
            handler: function(){
              Ext.Ajax.request({
                url: '/admin/matches/update_fouls/' + self.match_id,
                method: 'POST',
                params: {
                  'hosts[fouls]': Ext.getCmp('edit-match-hosts-fouls').getValue(),
                  'guests[fouls]': Ext.getCmp('edit-match-guests-fouls').getValue()
                },
                waitMsg: 'Обновляем фолы...'
              })
            }
          }
        ]
      })
    });
    Ext.apply(this, {
      title: 'Редактировать матч',
      width: 670,
      height: 400,
      minWidth: 700,
      minHeight: 400,
      autoScroll: true,
      layout: 'form',
      plain: true,
      bodyStyle: 'padding:5px;',
      buttonAlign: 'center',
      items: [
        this.form,
        this.grid
      ]
      /*buttons: [{
        text: 'Сохранить',
        handler: this.saveMatch.createDelegate(this)
      }, {
        text: 'Отмена',
        handler: this.closeDialog.createDelegate(this)
      }]*/
    });
    
    this.on('render', function(){
      this.grid.store.reload();
      Ext.Ajax.request({
        url: '/admin/matches/' + self.match_id + '/competitors',
        success: function(response){
          var competitors = Ext.decode(response.responseText);
          competitors.map(function(c){
            var fouls = Ext.getCmp('edit-match-'+c.side+'-fouls');
            fouls.setValue(c.fouls);
            fouls.setFieldLabel('Штрафные: ' + c.team_name);
          });
        }
      });
    });
    this.on('close', function(){
      Ext.ComponentMgr.get('matches-panel-matches-grid').store.reload();
    });
    
    MatchesPanel.EditMatchDialog.superclass.initComponent.apply(this, arguments);
  }
})


MatchesPanel.MatchesGrid = Ext.extend(Ext.grid.GridPanel, {
  initComponent: function() {
    Ext.apply(this, {
      disabled: true,
      store: new Ext.data.JsonStore({
        totalProperty: 'total_count',
        root: 'rows',
        restful: true,
        autoLoad: false,
        //url: '/admin/tours/1/matches',
        //autoLoad: true,
        fields:[
          {name: 'id'},
          {name: 'tour'},
          {name: 'date', type: 'date'},
          {name: 'hosts'},
          {name: 'guests'},
          {name: 'score'}
        ]
      }),
      columns:[
        {
          header: "id",
          width: 10,
          sortable: true,
          dataIndex: 'id'
        }, {
          header: "Дата",
          width: 30,
          sortable: true,
          dataIndex: 'date'
        }, {
          header: "Хозяева",
          width: 30,
          sortable: true,
          dataIndex: 'hosts'
        }, {
          header: "Гости",
          width: 30,
          sortable: true,
          dataIndex: 'guests'
        }, {
          header: "Счёт",
          width: 10,
          sortable: true,
          dataIndex: 'score'
        }, {
          header: "Действия",
          width: 20,
          sortable: false,
          dataIndex: 'id',
          renderer: function(val, p, record) {
            return ['<div style="text-align: center;">',
              '<a href="#" onclick="return MatchesPanel.handlers.editMatch(' + record.data.id + ');" style="margin-left:7px;"><img src="/images/icons/pencil.png" alt="Edit"  ext:qtip="Click to Edit" /></a>',
              '</div>'].join('');
          }
        }
      ],
      viewConfig: {forceFit:true},
      loadMask: true,
      autoHeight:true,
      
      addMatch: function(){
        dialog = new MatchesPanel.NewMatchDialog();
        dialog.show();
      }
    });
    
    Ext.apply(this, {
      bbar: new Ext.PagingToolbar({
        pageSize: ROWS_PER_PAGE,
        store: this.store,
        displayInfo: true
      }),
      tbar: new Ext.Toolbar({
        items: [{
          text: "Добавить матч",
          handler: this.addMatch.createDelegate(this),
          iconCls: 'add-item'
         }]
      })
    });
    
    MatchesPanel.MatchesGrid.superclass.initComponent.apply(this, arguments);
  }
});
Ext.reg("matches-matches-grid", MatchesPanel.MatchesGrid);

MatchesPanel.Panel = Ext.extend(Ext.FormPanel, {
  initComponent: function(){
    Ext.apply(this, {
      title: 'Матчи',
      frame: true,
      labelWidth: 100,
      width: 650,
      bodyStyle: 'padding:0 10px 0;',
      items: [
        {
          xtype: 'fieldset',
          id: 'matches-panel-league-selection',
          title: 'Выберите Лигу',
          autoHeight: true,
          items: [new Ext.form.ComboBox({
              id: 'matches-panel-tournament-combobox',
              fieldLabel: 'Турнир',
              displayField:'name',
              valueField: 'url',
              typeAhead: false,
              mode: 'local',
              forceSelection: true,
              triggerAction: 'all',
              emptyText: 'Выбрать турнир...',
              selectOnFocus:true,
              width: 206,
              allowBlank:false,
              store: new Ext.data.JsonStore({
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
                  MatchesPanel.handlers.tournamentSelected(this.value);
                }
              }
            }), new Ext.form.ComboBox({
              id: 'matches-panel-season-combobox',
              fieldLabel: 'Сезон',
              displayField: 'name',
              valueField: 'id',
              typeAhead: false,
              mode: 'local',
              forceSelection: true,
              triggerAction: 'all',
              emptyText: 'Выбрать сезон...',
              selectOnFocus:true,
              width: 206,
              disabled: true,
              allowBlank: false,
              store: new Ext.data.JsonStore({
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
                    MatchesPanel.handlers.seasonSelected(this.value);
                  }
                }
            }), new Ext.form.ComboBox({
              id: 'matches-panel-stage-combobox',
              fieldLabel: 'Этап',
              displayField: 'name',
              valueField: 'id',
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
                  MatchesPanel.handlers.stageSelected(this.value);
                }
              }
            }), new Ext.form.ComboBox({
              id: 'matches-panel-league-combobox',
              fieldLabel: 'Лига',
              displayField: 'name',
              valueField: 'id',
              typeAhead: false,
              mode: 'local',
              forceSelection: true,
              triggerAction: 'all',
              emptyText: 'Выбрать лигу...',
              selectOnFocus:true,
              width: 206,
              disabled: true,
              allowBlank: false,
              store: new Ext.data.JsonStore({
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
                  MatchesPanel.handlers.leagueSelected(this.value);
                }
              }
            })]
        }, {
          xtype: 'fieldset',
          id: 'matches-panel-tour-selection',
          title: 'Выберите Тур',
          autoHeight: true,
          items: [
            new Ext.form.ComboBox({
              id: 'matches-panel-tour-combobox',
              fieldLabel: 'Тур',
              displayField: 'name',
              valueField: 'id',
              typeAhead: false,
              mode: 'local',
              forceSelection: true,
              triggerAction: 'all',
              emptyText: 'Выбрать тур...',
              selectOnFocus:true,
              width: 206,
              disabled: true,
              allowBlank: false,
              store: new Ext.data.JsonStore({
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
                  MatchesPanel.handlers.tourSelected(this.value);
                }
              }
            }), new Ext.Button({
              text: 'Добавить',
              disabled: true,
              id: 'matches-panel-tour-newbutton',
              handler: function(e){
                var dialog = new MatchesPanel.NewTourDialog();
                dialog.show();
              }
            })
          ]
        }, {
          xtype: 'fieldset',
          title: 'Матчи',
          autoHeight: true,
          items: {
            xtype: 'matches-matches-grid',
            id: 'matches-panel-matches-grid'
          }
        }
      ]
    });
    MatchesPanel.Panel.superclass.initComponent.apply(this, arguments);
  }
});

Ext.reg("matchespanel", MatchesPanel.Panel);