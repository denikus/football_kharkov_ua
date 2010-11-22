Ext.ns('Ext.ux.tournament');
Ext.ux.tournament.MatchForm = function Panel(options) {
  var config = {
    frame: true,
    title: options.caption,
    bodyStyle: 'padding:5px',
    width: 450,
    layout: 'form',
    defaults: { msgTarget: 'side' },
    url: '/admin/matches/' + Ext.util.Format.undef(options.id),
    items: [
      { xtype: 'hidden', name: 'match[step_id]', value: options.step_id},
      { xtype: 'hidden', name: '_method', value: options.id ? 'PUT' : 'POST' },
      { xtype: 'datefield',
        fieldLabel: 'Дата',
        name: 'match[played_at]',
        allowBlank: false
      }, {
        xtype: 'combo',
        fieldLabel: 'Рефери',
        name: 'match[referee_id]',
        displayField: 'name',
        valueField: 'id',
        editable: false,
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Выберите Судью',
        selectOnFocus: true,
        value: options.referee_id,
        mode: 'local',
        store: new Ext.data.SimpleStore({fields: ['id', 'name'], data: Ext.ux.data.match.referees})
      }, {
        xtype: 'combo',
        fieldLabel: 'Тип Игры',
        name: 'match[match_type]',
        displayField: 'type',
        valueField: 'id',
        editable: false,
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Выберите Судью',
        selectOnFocus: true,
        value: options.match_type || 'mini',
        mode: 'local',
        store: new Ext.data.SimpleStore({fields: ['id', 'type'], data: Ext.ux.data.match.types})
      }, {
        xtype: 'textfield',
        fieldLabel: 'Длительность',
        name: 'match[period_duration]',
        value: options.period_duration || 25,
        allowBlank: false
      }, {
        xtype: 'textarea',
        fieldLabel: 'Заметки',
        name: 'match[comment]',
        value: options.comment,
        anchor: '95%',
        allowBlank: true
      }
    ],
    buttons: [{
      text: 'Сохранить',
      handler: (function() {
        this.getForm().submit({
          success: function(form, action) {
            options.node.reload();
            app.master.removeAll(true);
          },
          waitMsg: 'Подождите...'
        });
      }).createDelegate(this)
    }]
  }
  Panel.superclass.constructor.call(this, config);
}

Ext.extend(Ext.ux.tournament.MatchForm, Ext.FormPanel);
