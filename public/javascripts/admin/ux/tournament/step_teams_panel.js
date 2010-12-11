Ext.ns('Ext.ux.tournament');

(function() {
  Ext.ux.tournament.StepTeamsGrid = function Panel(step_id, selected) {
    var columns = [{
      dataIndex: 'id',
      header: 'ID',
      width: 30,
      sortable: true,
      hidden: true
    }, {
      id: (selected ? 'selected' : 'remaining') + '-name-col',
      dataIndex: 'name',
      header: 'Имя',
      width: 150,
      sortable: true
    }, {
      dataIndex: 'url',
      header: 'url',
      width: 150,
      sortable: true
    }];
    var store = createStore(step_id, selected);
    var config = {
      id: 'step-' + step_id + '-teams-' + (selected ? 'selected' : 'remaining') + '-grid',
      title: selected ? 'Выбранные' : 'Оставшиеся',
      enableDragDrop: true,
      ddGroup: 'step-' + step_id + '-' + (selected ? 'Selected' : 'Remaining') + 'TeamsDDGroup',
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
    Panel.superclass.constructor.call(this, config);
    this.on('render', this.createDropTarget.createDelegate(this, [step_id, !selected]));
  }
  Ext.extend(Ext.ux.tournament.StepTeamsGrid, Ext.grid.GridPanel, {
    createDropTarget: function(step_id, selected) {
      var el = this.getView().el.dom.childNodes[0].childNodes[1];
      this.dropTarget = new Ext.dd.DropTarget(el, {
        ddGroup: 'step-' + step_id + '-' + (selected ? 'Selected' : 'Remaining') + 'TeamsDDGroup',
        copy: true,
        notifyDrop: function(ddSource, e, data) {
          var store = Ext.getCmp('step-' + step_id + '-teams-' + (selected ? 'remaining' : 'selected') + '-grid').store;
          var selected_store = Ext.getCmp('step-' + step_id + '-teams-selected-grid').store;
          function addRow(record, index, allItems) {
            var found = store.find('title', record.data.name);
            if (found == -1) {
              store.add(record);
              store.sort('name', 'ASC');
              ddSource.grid.store.remove(record);
            }
          }
          Ext.each(ddSource.dragData.selections, addRow);
          Ext.Ajax.request({
            url: '/admin/steps/' + step_id + '/update_teams',
            params: {team_ids: selected_store.data.items.map(function(record){ return record.id }).join(',')}
          });
          return true;
        }
      });
    }
  });
  
  function createStore(step_id, selected) {
    return new Ext.data.JsonStore({
      url: '/admin/steps/' + step_id + '/teams',
      root: selected ? 'selected' : 'remaining',
      totalProperty: selected ? 'selected_count' : 'remaining_count',
      fields: ['id', 'name', 'url'],
      autoLoad: true,
      requestMethod: 'GET'
    });
  }
})();

Ext.ux.tournament.StepTeamsPanel = function Panel(step_id) {
  var config = {
    title: 'Команды',
    layout: 'column',
    items: [
      new Ext.ux.tournament.StepTeamsGrid(step_id, true),
      new Ext.ux.tournament.StepTeamsGrid(step_id, false)
    ]
  }
  Panel.superclass.constructor.call(this, config)
}

Ext.extend(Ext.ux.tournament.StepTeamsPanel, Ext.Panel);
