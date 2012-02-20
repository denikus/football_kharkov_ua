Ext.namespace("SeasonDialog");
SeasonDialog = Ext.extend(Ext.Window, {
  initComponent: function() {
    // simple array store
    var store = new Ext.data.JsonStore({
                  id:'id'
                 ,method: 'get'
                 ,restful: true
                 ,root: 'rows'
                 ,autoLoad: true
                 ,url:'/admin/tournaments'
                 ,fields:[
                    {name:'id'}
                   ,{name:'name'}
                   ,{name:'url'}
                 ]
              })
    var combo = new Ext.form.ComboBox({
        store: store
        ,displayField:'name'
        ,valueField: 'id'
        ,hiddenName:'season[tournament_id]'
        ,name: 'tournament_id'
        ,typeAhead: false
        ,mode: 'local'
        ,forceSelection: true
        ,triggerAction: 'all'
        ,emptyText:'Выбрать чемпионат...'
        ,selectOnFocus:true
    });
    Ext.apply(this, {
      form: new Ext.form.FormPanel({
                      baseCls: 'x-plain',
                      labelWidth: 55,
                      url:'/admin/seasons',
                      defaultType: 'textfield',
                      baseParams: {format: 'ext_json'},
                      items: [{
                        fieldLabel: 'Название',
                        name: 'season[name]',
                        anchor:'100%'  // anchor width by percentage
                      }
                      ,{
                        fieldLabel: 'URL',
                        name: 'season[url]',
                        anchor: '100%'  // anchor width by percentage
                      }
                      , combo]
                  })
    });

    var config = {
        title: 'Новый сезон',
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

    Ext.apply(this, config);

    SeasonDialog.superclass.initComponent.apply(this, arguments);
  }
  ,saveItem: function() {
    var mmm = this.closeDialog.createDelegate(this)
    this.form.getForm().submit({
      success: function(form, action) {
        Ext.Msg.alert('Статус', 'Запись успешно сохранена!');
        mmm();
      }
      ,failure: function(form, action) {
      }
    });
  }
  ,closeDialog: function() {
    this.close();
  }
});
Ext.reg("SeasonDialog", SeasonDialog);