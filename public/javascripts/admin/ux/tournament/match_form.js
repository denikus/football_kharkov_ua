Ext.ns('Ext.ux.tournament');
Ext.ux.tournament.MatchForm = function Panel(options) {
  var config = {
    title: options.caption,
    layout: 'anchor',
    width: 630,
    items: [
      new Panel.QuickForm(options),
      new Panel.ExtendedForm(options)
    ]
  }
  Panel.superclass.constructor.call(this, config);
}

Ext.extend(Ext.ux.tournament.MatchForm, Ext.Panel);

Ext.ux.tournament.MatchForm.QuickForm = function Panel(options) {
  var config = {
    frame: true,
    title: 'Быстрая информация',
    bodyStyle: 'padding:5px',
    anchor: '100%',
    layout: 'table',
    layoutConfig: {columns: 4},
    defaults: {msgTarget: 'side', bodyStyle: 'width: 80px'},
    url: '/admin/schedules/' + Ext.util.Format.undef(options.id) + '/update_results',
    items: [
      {items: [{xtype: 'hidden', name: 'match[step_id]'}, {xtype: 'hidden', name: '_method', value: 'POST'}]},
        {title: 'Голы'},
        {title: 'Фолы ПТ'},
        {title: 'Фолы ВТ'},
      {title: options.hosts},
        {xtype: 'numberfield', name: 'hosts[score]', width: 50, style: 'margin-left:15px; text-align: right;'},
        {xtype: 'numberfield', name: 'hosts[first_period_fouls]', width: 50, style: 'margin-left:15px; text-align: right;'},
        {xtype: 'numberfield', name: 'hosts[second_period_fouls]', width: 50, style: 'margin-left:15px; text-align: right;'},
      {title: options.guests},
        {xtype: 'numberfield', name: 'guests[score]', width: 50, style: 'margin-left:15px; text-align: right;'},
        {xtype: 'numberfield', name: 'guests[first_period_fouls]', width: 50, style: 'margin-left:15px; text-align: right;'},
        {xtype: 'numberfield', name: 'guests[second_period_fouls]', width: 50, style: 'margin-left:15px; text-align: right;'}
    ],
    buttons: [{
      text: 'Сохранить',
      handler: (function() {
        this.getForm().submit({ waitMsg: 'Подождите...' });
      }).createDelegate(this)
    }]
  };
  Panel.superclass.constructor.call(this, config);
  
  this.on('render', function() {
    this.getForm().load({
      url: '/admin/schedules/' + Ext.util.Format.undef(options.id) + '/results',
      method: 'GET',
      waitMsg: 'Получение данных...'
    })
  })
}
Ext.extend(Ext.ux.tournament.MatchForm.QuickForm, Ext.FormPanel);

Ext.ux.tournament.MatchForm.ExtendedForm = function Panel(options) {
  this.match_id = Ext.util.Format.undef(options.match_id);
  var self = this;
  var config = {
    frame: true,
    title: 'Полная информация',
    bodyStyle: 'padding:5px',
    anchor: '100%',
    layout: 'form',
    defaults: { msgTarget: 'side' },
    url: '/admin/matches/' + this.match_id + '/update_results',
    items: [
      { xtype: 'hidden', name: 'match[step_id]'},
      { xtype: 'hidden', name: '_method', value: 'POST' },
      {
        xtype: 'fieldset',
        layout: 'column',
        collapsible: false,
        collapsed: false,
        items: [{
          xtype: 'button',
          columnWidth: .2,
          id: 'match-extended-referees-btn',
          text: 'Судьи...',
          handler: this.manageReferees.createDelegate(this)
        }, {
          columnWidth: .8,
          id: 'match-extended-referees-txt',
          bodyStyle: 'padding: 4px 0 0 6px',
          html: 'Судьи...'
        }]
      }, {
        xtype: 'fieldset',
        title: 'Данные футболистов',
        autoHeight: true,
        collapsed: false,
        collapsible: false,
        layout: 'anchor',
        items: [new Panel.PlayerTabsPanel(options)]
      }
    ],
    buttons: [{
      text: 'Сохранить',
      handler: (function() {
        this.getForm().submit({
          success: function() {
            Ext.getCmp('match-events-grid').store.reload();
          },
          waitMsg: 'Подождите...'
        });
      }).createDelegate(this)
    }]
  }
  Panel.superclass.constructor.call(this, config);
  
  this.on('render', function() {
    this.getForm().load({
      url: '/admin/matches/' + Ext.util.Format.undef(options.match_id) + '/results?footballer_ids='+options.hosts_footballer_ids+','+options.guests_footballer_ids,
      method: 'GET',
      waitMsg: 'Получение данных...',
      success: function(form, action) {
        var data = action.result.data;
        self.referees = action.result.data.referees;
        Ext.getCmp('match-extended-referees-btn').setText(self.refereesButtonText());
        Ext.getCmp('match-extended-referees-txt').body.dom.innerHTML = self.refereesText();
        Ext.getCmp('extended-form-tabs-panel').activate(0);
        for(var id in data.footballer_names) {
          Ext.get('footballer-name-'+id).dom.childNodes[0].childNodes[0].innerHTML = data.footballer_names[id];
        }
        Ext.getCmp('extended-form-tabs-panel').enable();
      }
    })
  })
}
Ext.extend(Ext.ux.tournament.MatchForm.ExtendedForm, Ext.FormPanel, {
  refereesButtonText: function() {
    var total = 0;
    for(var id in this.referees) total++;
    return "Судьи (" + total + ")...";
  },
  refereesText: function() {
    var text = [];
    for(var id in this.referees) text.push(this.referees[id]);
    return Ext.util.Format.ellipsis(text.join(', '), 77, false);
  },
  manageReferees: function() {
    var referees = [];
    for(var id in this.referees) referees.push(combo(id));
    referees.push(combo());
    var self = this;
    var referees_form = {
      xtype: 'form',
      id: 'match-extended-referees-form',
      bodyStyle: 'padding: 5px; background: transparent',
      border: false,
      url: '/admin/matches/' + this.match_id + '/update_referees',
      items: [referees],
      buttons: [{
        text: 'Добавить Судью',
        handler: function() {
          Ext.getCmp('match-extended-referees-form').items.add(combo());
          Ext.getCmp('match-extended-referees-form').doLayout();
        }
      }, {
        text: 'Удалить Судью',
        handler: function() {
          with(Ext.getCmp('match-extended-referees-form')) {
            if(items.length > 1) remove(items.items[items.length-1]);
          }
        }
      }, {
        text: 'Сохранить',
        handler: function() {
          Ext.getCmp('match-extended-referees-form').getForm().submit({
            success: function(form, action) {
              self.referees = action.result.referees;
              Ext.getCmp('match-extended-referees-btn').setText(self.refereesButtonText());
              Ext.getCmp('match-extended-referees-txt').body.dom.innerHTML = self.refereesText();
              Ext.getCmp('match-extended-referees-wnd').close();
            },
            waitMsg: 'Подождите...'
          })
        }
      }]
    };
    var window = new Ext.Window({
      id: 'match-extended-referees-wnd',
      layout: 'form',
      title: 'Судейство',
      width: 400,
      autoHeight: true,
      y: 300,
      items: [referees_form]
    });
    window.show();
    
    function combo(id) {
      return new Ext.form.ComboBox({
        fieldLabel: 'Рефери',
        displayField: 'name',
        name: 'match[referee_ids][]',
        value: id,
        hiddenName: 'match[referee_ids][]',
        hiddenValue: id,
        valueField: 'id',
        editable: false,
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Выберите Судью',
        mode: 'local',
        store: new Ext.data.ArrayStore({fields: ['id', 'name'], data: Ext.ux.data.match.referees})
      });
    }
  }
});

Ext.ux.tournament.MatchForm.ExtendedForm.PlayerTabsPanel = function Panel(options) {
  var config = {
    id: 'extended-form-tabs-panel',
    activeTab: 1,
    anchor: '100%',
    height: 250,
    disabled: true,
    defaults: { autoScroll: true },
    bodyStyle: 'background-color: #DFE8F6;',
    items: [
      Panel.createPlayerItems('hosts', options),
      Panel.createPlayerItems('guests', options),
    ]
  };
  Panel.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.tournament.MatchForm.ExtendedForm.PlayerTabsPanel, Ext.TabPanel);
Ext.ux.tournament.MatchForm.ExtendedForm.PlayerTabsPanel.createPlayerItems = function(key, options) {
  var ids = options[key+'_footballer_ids'];
  var items = [{title: 'Имя'}, {title: 'Номер'}, {title: 'Голы'}, {title: 'Г-10м'}, {title: 'Г-6м'}, {title: 'AвтГл'}, {title: 'К-К'}, {title: 'Ж-К'}];
  for(var i=0, l=ids.length; i<l; i++) {
    items = items.concat({id: 'footballer-name-' + ids[i], html: 'Футболист' + ids[i]},
      {xtype: 'textfield', name: key+'['+ids[i]+'][number]', width: 50},
      {xtype: 'textfield', name: key+'['+ids[i]+'][goal]', width: 50},
      {xtype: 'textfield', name: key+'['+ids[i]+'][goal_10]', width: 50},
      {xtype: 'textfield', name: key+'['+ids[i]+'][goal_6]', width: 50},
      {xtype: 'textfield', name: key+'['+ids[i]+'][auto_goal]', width: 50},
      {xtype: 'textfield', name: key+'['+ids[i]+'][red_card]', width: 50},
      {xtype: 'textfield', name: key+'['+ids[i]+'][yellow_card]', width: 50}
    )
  }
  return {
    title: options[key],
    xtype: 'panel',
    layout: 'table',
    layoutConfig: { columns: 8 },
    id: key + '-tab',
    items: items
  }
}
