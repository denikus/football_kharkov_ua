Ext.ns('Ext.ux.tournament');
Ext.ux.tournament.MatchEventsGrid = function Grid(match_id) {
  var self = this;
  var store = new Ext.data.JsonStore({
    url: '/admin/matches/' + match_id + '/match_events',
    restful: true,
    root: 'data',
    successProperty: 'success',
    idProperty: 'id',
    fields: Grid.Event,
    writer: new Ext.data.JsonWriter(),
    autoLoad: true,
    sortInfo: {field: 'minute', direction: 'DESC'}
  });
  var editor = new Ext.ux.grid.RowEditor({
    saveText: 'Сохранить',
    cancelText: 'Отмена',
    listeners: {
      'afteredit': function(){ store.reload() }
    }
  })
  var config = {
    id: 'match-events-grid',
    store: store,
    width: 630,
    height: 300,
    autoExpandColumn: 'message',
    plugins: [editor],
    loadMask: true,
    columns: [
      { header: 'id', width: 30, dataIndex: 'id', sortable: true, hidden: true },
      { id: 'minute',
        header: 'Минута',
        width: 50,
        dataIndex: 'minute',
        sortable: true,
        editor: new Ext.form.NumberField({
          allowBlank: false,
          allowNegative: false,
          style: 'text-align: right'
        })
      }, {
        id: 'message',
        header: 'Текст',
        width: 600,
        dataIndex: 'message',
        sortable: false,
        editor: new Ext.form.TextField({allowBlank: false})
      }
    ],
    tbar: [{
      iconCls: 'icon-add',
      text: 'Добавить Событие',
      handler: function() {
        var e = new Grid.Event({minute: '', message: ''});
        editor.stopEditing();
        store.insert(0, e);
        self.getSelectionModel().selectRow(0);
        editor.startEditing(0);
      }
    }, {
      iconCls: 'icon-delete',
      text: 'Удалить Событие',
      disabled: true,
      id: 'match-events-delete-btn',
      handler: function() {
        editor.stopEditing();
        var s = self.getSelectionModel().getSelections();
        for(var i=0, r; r=s[i]; i++) {
          store.remove(r);
        }
      }
    }]
  };
  Grid.superclass.constructor.call(this, config);
  this.getSelectionModel().on('selectionchange', function(sm) {
    Ext.getCmp('match-events-delete-btn').setDisabled(this.getCount() < 1);
  });
}
Ext.extend(Ext.ux.tournament.MatchEventsGrid, Ext.grid.GridPanel);
Ext.ux.tournament.MatchEventsGrid.Event = Ext.data.Record.create([
  { name: 'id' },
  { name: 'minute', type: 'integer' },
  { name: 'message', type: 'string' }
])
