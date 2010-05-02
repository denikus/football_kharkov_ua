Ext.namespace("TournamentDialog");
TournamentDialog = Ext.extend(Ext.Window, {
  initComponent: function() {
    Ext.apply(this, {
      form: new Ext.form.FormPanel({
                      baseCls: 'x-plain',
                      labelWidth: 55,
                      url:'/admin/tournaments',
                      defaultType: 'textfield',
                      baseParams: {format: 'ext_json'},
                      items: [{
                        fieldLabel: 'Название',
                        name: 'tournament[name]',
                        anchor:'100%'  // anchor width by percentage
                      }
                      ,{
                        fieldLabel: 'URL',
                        name: 'tournament[url]',
                        anchor: '100%'  // anchor width by percentage
                      }]
                  })
    });

    var config = {
        title: 'Новый турнир',
        width: 300,
        height:150,
        minWidth: 100,
        minHeight: 100,
        layout: 'fit',
        plain:true,
        bodyStyle:'padding:5px;',
        buttonAlign:'center',
        items: this.form,
        buttons: [{
            text: 'Send'
           ,handler: this.saveItem.createDelegate(this)
        },{
            text: 'Cancel'
           ,handler: this.closeDialog.createDelegate(this)
        }]
    }

//    window.show();
    Ext.apply(this, config);

    TournamentDialog.superclass.initComponent.apply(this, arguments);
  }
  ,saveItem: function() {
    var mmm = this.closeDialog.createDelegate(this)
    this.form.getForm().submit({
      success: function(form, action) {
        Ext.Msg.alert('Статус', 'Запись успешно сохранена!');
//        Ext.MessageBox.alert('Status', 'Changes saved successfully.', showResult);

        mmm();
//        alert(form.el.parent);
//        this.closeDialog.createDelegate(this);
//        Ext.Msg.alert('Success', action.result.msg);
      }
      ,failure: function(form, action) {
      }
    });
  }
  ,closeDialog: function() {
    this.close();
  }
});
Ext.reg("tournamentdialog", TournamentDialog);