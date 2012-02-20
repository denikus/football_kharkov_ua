Ext.ns('Ext.ux.personnel');

Ext.ux.personnel.Grid = function Grid(type) {
  var store = Grid.createStore(type);
  var config = {
    store: store,
    columns: Grid.columns[type],
    autoExpandColumn: 'name-col',
    width: 600,
    height: 300,
    loadMask: true,
    columnLines: true,
    viewConfig: {
      forceFit: true
    },
//    tbar: [' ', new Ext.ux.common.NameFilter(store)]
    tbar: [' ', new Ext.ux.form.SearchField({store: store})]
  }
  Grid.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.personnel.Grid, Ext.grid.GridPanel, {
  bindTo: function(form) {
    this.getSelectionModel().on('rowselect', function(sm, index, record) {
      form.getForm().loadRecord(record);
      form.setId(record.data.id);
    });
  }
});
Ext.ux.personnel.Grid.createStore = function Store(type) {
  var store = new Ext.data.JsonStore({
    url: '/admin/' + type + '.json',
    root: 'personnel',
    totalProperty: 'count',
    fields: Store.fields[type],
    autoLoad: false,
    restful: true

  });
  store.setDefaultSort(type == 'teams' ? 'name' : 'last_name', 'asc');
  return store;
}
Ext.ux.personnel.Grid.columns = {
  footballers: [
    {header: 'ID', width: 30, dataIndex: 'id', sortable: true, hidden: true},
    {header: 'Имя', width: 150, dataIndex: 'first_name', sortable: true},
    {header: 'Фамилия', width: 150, dataIndex: 'last_name', sortable: true, id: 'name-col'},
    {header: 'Отчество', width: 150, dataIndex: 'patronymic', sortable: true},
    {header: 'ДР', dataIndex: 'birth_date', xtype: 'datecolumn', format: 'M d, Y'},
    {header: 'url', dataIndex: 'url', sortable: true}
  ],
  referees: [
    {header: 'ID', width: 30, dataIndex: 'id', sortable: true, hidden: true},
    {header: 'Имя', width: 150, dataIndex: 'first_name', sortable: true},
    {header: 'Фамилия', width: 150, dataIndex: 'last_name', sortable: true, id: 'name-col'},
    {header: 'Отчество', width: 150, dataIndex: 'patronymic', sortable: true},
    {header: 'ДР', dataIndex: 'birth_date', xtype: 'datecolumn', format: 'M d, Y'}
  ],
  teams: [
    {header: 'ID', width: 30, dataIndex: 'id', sortable: true, hidden: true},
    {header: 'Имя', dataIndex: 'name', sortable: true, id: 'name-col'},
    {header: 'url', dataIndex: 'url', sortable: true}
  ]
}
Ext.ux.personnel.Grid.createStore.fields = {
  footballers: ['name', 'first_name', 'last_name', 'patronymic', 'url', {name: 'birth_date', type: 'date'}, {name: 'id', type: 'int'}],
  referees: ['name', 'first_name', 'last_name', 'patronymic', {name: 'birth_date', type: 'date'}, {name: 'id', type: 'int'}],
  teams: ['name', 'url', {name: 'id', type: 'int'}]
}

Ext.ux.personnel.Panel = function Panel(type) {
  var grid = new Ext.ux.personnel.Grid(type);
  grid.bindTo(this);
  var config = {
    id: 'personnel-form',
    frame: true,
    labelAlign: 'left',
    title: Panel.titles[type],
    bodyStyle: 'padding: 5px',
    width: 1000,
    layout: 'column',
    items: [{
      columnWidth: .65,
      items:[grid]
    }, Panel.createFieldset(type)],
    buttons: [{
      text: 'Сохранить',
      handler: (function() {
        var self = this;
        this.getForm().submit({
          url: '/admin/' + type + (this.personnel_id ? ('/' + this.personnel_id) : '') + '.json',
          params: {
            _method: this.personnel_id ? 'PUT' : 'POST'
          },
          success: function(form, action) {
            grid.store.reload();
            self.setId(0);
          },
          waitMsg: 'Подождите...'
        });
      }).createDelegate(this)
    }, {
      id: 'personnel-form-delete-btn',
      text: 'Удалить',
      disabled: true,
      handler: (function() {
        var self = this;
        var box = Ext.MessageBox.wait('Пожалуйста, подождите', 'Обработка запроса');
        Ext.Ajax.request({
          url: '/admin/' + type + '/' + this.personnel_id,
          params: {_method: 'DELETE'},
          success: function() {
            box.hide();
            grid.store.reload();
            self.setId(0);
          }
        });
      }).createDelegate(this)
    }, {
      id: 'personnel-form-cancel-btn',
      text: 'Отменить',
      disabled: true,
      handler: (function() {
        grid.getSelectionModel().clearSelections();
        this.setId(0);
      }).createDelegate(this)
    }]
  }
  Panel.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.personnel.Panel, Ext.FormPanel, {
  setId: function(id) {
    this.personnel_id = id;
    Ext.getCmp('personnel-form-delete-btn')[this.personnel_id ? 'enable' : 'disable']();
    Ext.getCmp('personnel-form-cancel-btn')[this.personnel_id ? 'enable' : 'disable']();
    var nav = Ext.getCmp('nav-team-footballers');
    if(nav) {
      nav[this.personnel_id ? 'enable' : 'disable']();
      nav.collapseAll();
      nav.getSelectionModel().clearSelections();
      app.details.removeAll();
    }
    if(!this.personnel_id) {
      this.getForm().reset();
    }
  }
});
Ext.ux.personnel.Panel.titles = {
  footballers: 'Футболисты',
  referees: 'Судьи',
  teams: 'Команды'
}
Ext.ux.personnel.Panel.createFieldset = function(type) {
  var set = {
    columnWidth: .35,
    xtype: 'fieldset',
    labelWidth: 90,
    title: 'Информация',
    defaults: {width: 180},
    defaultType: 'textfield',
    autoHeight: true,
    bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;'
  };
  if(type == 'footballers' || type == 'referees') {
    set.items = [{
      id: 'first_name',
      fieldLabel: 'Имя',
      name: type + '[first_name]'
    }, {
      id: 'last_name',
      fieldLabel: 'Фамилия',
      name: type + '[last_name]'
    }, {
      id: 'patronymic',
      fieldLabel: 'Отчество',
      name: type + '[patronymic]'
    }, {
      id: 'birth_date',
      fieldLabel: 'ДР',
      name: type + '[birth_date]',
      xtype: 'datefield'
    }];
    if(type == 'footballers') {
      set.items.push({
        id: 'url',
        fieldLabel: 'url',
        name: type + '[url]'
      })
    }
  } else if(type == 'teams') {
    set.items = [{
      id: 'name',
      fieldLabel: 'Название',
      name: type + '[name]'
    }, {
      id: 'url',
      fieldLabel: 'url',
      name: type + '[url]'
    }]
  }
  return set;
}
