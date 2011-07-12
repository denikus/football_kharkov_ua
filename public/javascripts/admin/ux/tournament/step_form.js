Ext.ns('Ext.ux.tournament');
Ext.ux.tournament.StepForm = function Panel(options) {
  var config = {
    frame: true,
    title: options.caption,
    bodyStyle: 'padding:5px',
    width: 450,
    layout: 'form',
    defaults: { msgTarget: 'side' },
    url: '/admin/steps/' + Ext.util.Format.undef(options.id),
    items: [
      { xtype: 'hidden', name: 'step[type]', value: options.type},
      { xtype: 'hidden', name: 'step[tournament_id]', value: options.tournament_id},
      { xtype: 'hidden', name: 'step[parent_id]', value: options.parent_id},
      { xtype: 'hidden', name: '_method', value: options.id ? 'PUT' : 'POST' },
      { xtype: 'textfield',
        fieldLabel: 'Идентификатор',
        name: 'step[identifier]',
        anchor: '95%',
        value: options.identifier,
        allowBlank: true
      }, { xtype: 'textfield',
        fieldLabel: 'Имя',
        name: 'step[name]',
        anchor: '95%',
        value: options.name,
        allowBlank: true
      }, { xtype: 'textfield',
        fieldLabel: 'url',
        name: 'step[url]',
        anchor: '95%',
        value: options.url,
        allowBlank: true
      }, { xtype: 'checkbox',
          fieldLabel: 'Плей-офф',
          name: 'step[step_properties][playoff]',
          checked: options.playoff,
          value: options.playoff,
          hidden: options.type != 'StepStage'
      },
          { xtype: 'checkbox',
          fieldLabel: 'Бонус в рейтинг',
          name: 'step[bonus_point]',
          checked: options.bonus_point,
          value: options.bonus_point,
          hidden: options.type != 'StepLeague'
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
  if(options.id) {
    config.buttons.push({
      text: 'Удалить',
      handler: (function() {
        var loadMask = new Ext.LoadMask(Ext.getBody(), {msg: 'Подождите...'});
        loadMask.show();
        Ext.Ajax.request({
          url: '/admin/steps/' + options.id,
          params: {'_method': 'DELETE'},
          success: function(response) {
            loadMask.hide();
            options.node.reload();
            app.master.removeAll(true);
          }
        })
      }).createDelegate(this)
    })
  }
  Panel.superclass.constructor.call(this, config);
}

Ext.extend(Ext.ux.tournament.StepForm, Ext.FormPanel);
