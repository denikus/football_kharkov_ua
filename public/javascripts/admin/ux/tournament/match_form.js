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
        {xtype: 'textfield', name: 'hosts[score]', width: 50, style: 'margin-left:15px;'},
        {xtype: 'textfield', name: 'hosts[first_period_fouls]', width: 50, style: 'margin-left:15px;'},
        {xtype: 'textfield', name: 'hosts[second_period_fouls]', width: 50, style: 'margin-left:15px;'},
      {title: options.guests},
        {xtype: 'textfield', name: 'guests[score]', width: 50, style: 'margin-left:15px;'},
        {xtype: 'textfield', name: 'guests[first_period_fouls]', width: 50, style: 'margin-left:15px;'},
        {xtype: 'textfield', name: 'guests[second_period_fouls]', width: 50, style: 'margin-left:15px;'}
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
      waitMsg: 'Обновление данных...'
    })
  })
}
Ext.extend(Ext.ux.tournament.MatchForm.QuickForm, Ext.FormPanel);

Ext.ux.tournament.MatchForm.ExtendedForm = function Panel(options) {
  var config = {
    frame: true,
    title: 'Полная информация',
    bodyStyle: 'padding:5px',
    anchor: '100%',
    layout: 'form',
    defaults: { msgTarget: 'side' },
    url: '/admin/matches/' + Ext.util.Format.undef(options.match_id) + '/update_results',
    items: [
      { xtype: 'hidden', name: 'match[step_id]'},
      { xtype: 'hidden', name: '_method', value: 'POST' },
      /*{
        xtype: 'combo',
        fieldLabel: 'Рефери',
        name: 'match[referee_ids][]',
        displayField: 'name',
        valueField: 'id',
        editable: false,
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Выберите Судью',
        selectOnFocus: true,
        mode: 'local',
        store: new Ext.data.SimpleStore({fields: ['id', 'name'], data: Ext.ux.data.match.referees})
      }, */{
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
          waitMsg: 'Подождите...'
        });
      }).createDelegate(this)
    }/*, {
      text: 'Добавить Судью',
      handler: (function() { alert('adding') }).createDelegate(this)
    }, {
      text: 'Удалить Судью',
      handler: (function() { alert('removing') }).createDelegate(this)
    }*/]
  }
  Panel.superclass.constructor.call(this, config);
  
  this.on('render', function() {
    this.getForm().load({
      url: '/admin/matches/' + Ext.util.Format.undef(options.match_id) + '/results?footballer_ids='+options.hosts_footballer_ids+','+options.guests_footballer_ids,
      method: 'GET',
      waitMsg: 'Обновление данных...',
      success: function(form, action) {
        Ext.getCmp('extended-form-tabs-panel').activate(0);
        var data = action.result.data;
        for(var id in data.footballer_names) {
          Ext.get('footballer-name-'+id).dom.childNodes[0].childNodes[0].innerHTML = data.footballer_names[id];
        }
        Ext.getCmp('extended-form-tabs-panel').enable();
      }
    })
  })
}
Ext.extend(Ext.ux.tournament.MatchForm.ExtendedForm, Ext.FormPanel);

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
