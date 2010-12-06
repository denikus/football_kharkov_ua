Ext.ns('Ext.ux.personnel');

Ext.ux.personnel.TeamFootballersGrid = function Panel(options) {
  with(options) {
    var store = new Ext.data.JsonStore({
      url: '/admin/teams/' + team_id + '/footballers?step_id=' + options.step_id,
      root: selected ? 'selected' : 'remaining',
      totalProperty: selected ? 'selected_count' : 'remaining_count',
      fields: ['name', 'first_name', 'last_name', 'patronymic', 'url', {name: 'birth_date', type: 'date'}, {name: 'id', type: 'int'}],
      autoLoad: true,
      requestMethod: 'GET'
    });
    var columns = [
      {header: 'ID', width: 30, dataIndex: 'id', sortable: true, hidden: true},
      {header: 'Имя', width: 150, dataIndex: 'first_name', sortable: true},
      {header: 'Фамилия', width: 150, dataIndex: 'last_name', sortable: true, id: (selected ? 'selected' : 'remaining') + '-name-col'},
      {header: 'Отчество', width: 150, dataIndex: 'patronymic', sortable: true},
      {header: 'ДР', dataIndex: 'birth_date', xtype: 'datecolumn', format: 'M d, Y'},
      {header: 'url', dataIndex: 'url', sortable: true}
    ];
    var config = {
      id: 'team-' + team_id + '-footballers-' + (selected ? 'selected' : 'remaining') + '-grid',
      title: selected ? 'Выбранные' : 'Оставшиеся',
      enableDragDrop: true,
      ddGroup: 'team-' + team_id + '-' + (selected ? 'Selected' : 'Remaining') + 'TeamsDDGroup',
      store: store,
      columns: columns,
      autoExpandColumn: (selected ? 'selected' : 'remaining') + '-name-col',
      loadMask: true,
      columnLines: true,
      viewConfig: {forceFit: true},
      height: 300,
      columnWidth: .5
    }
    if(!selected) {
      config.tbar = [' ', new Ext.ux.common.NameFilter(store)];
    }
  }
  Panel.superclass.constructor.call(this, config);
  this.on('render', this.createDropTarget.createDelegate(this, [options.team_id, !options.selected, options.step_id]));
}
Ext.extend(Ext.ux.personnel.TeamFootballersGrid, Ext.grid.GridPanel, {
  createDropTarget: function(team_id, selected, step_id) {
    var el = this.getView().el.dom.childNodes[0].childNodes[1];
    this.dropTarget = new Ext.dd.DropTarget(el, {
      ddGroup: 'team-' + team_id + '-' + (selected ? 'Selected' : 'Remaining') + 'TeamsDDGroup',
      copy: true,
      notifyDrop: function(ddSource, e, data) {
        var store = Ext.getCmp('team-' + team_id + '-footballers-' + (selected ? 'remaining' : 'selected') + '-grid').store;
        var selected_store = Ext.getCmp('team-' + team_id + '-footballers-selected-grid').store;
        function addRow(record, index, allItems) {
          var found = store.find('title', record.data.name);
          if (found == -1) {
            store.add(record);
            store.sort('last_name', 'ASC');
            ddSource.grid.store.remove(record);
          }
        }
        Ext.each(ddSource.dragData.selections, addRow);
        Ext.Ajax.request({
          url: '/admin/teams/' + team_id + '/update_footballers?step_id=' + step_id,
          params: {footballer_ids: selected_store.data.items.map(function(record){ return record.id }).join(',')}
        });
        return true;
      }
    });
  }
});

Ext.ux.personnel.TeamFootballersPanel = function Panel(team_id, step_id) {
  var config = {
    title: 'Футболисты',
    layout: 'column',
    items: [
      new Ext.ux.personnel.TeamFootballersGrid({team_id: team_id, step_id: step_id, selected: true}),
      new Ext.ux.personnel.TeamFootballersGrid({team_id: team_id, step_id: step_id, selected: false})
    ]
  }
  Panel.superclass.constructor.call(this, config)
}

Ext.extend(Ext.ux.personnel.TeamFootballersPanel, Ext.Panel);
