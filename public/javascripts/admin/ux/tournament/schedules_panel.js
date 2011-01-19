Ext.ns('Ext.ux.tournament');

Ext.ux.tournament.SchedulesPanel = function Panel(options) {
  var config = {
    id: 'tournament-schedules-panel',
    title: 'Расписание: ',
    layout: 'table',
    layoutConfig: {columns: 8},
    defaults: {width: 150, height: 27},
    items: [{width: 40, title: '&nbsp;'}, {title: 'Воскресенье'}, {title: 'Понедельник'}, {title: 'Вторник'}, {title: 'Среда'}, {title: 'Четверг'}, {title: 'Пятница'}, {title: 'Суббота'}]
  }
  Ext.apply(this, options);
  with(this) {
    this.startDate = date.add(Date.DAY, -date.getDay());
    this.endDate = date.add(Date.DAY, 6-date.getDay());
    config.title += (startDate.format('d/m') + ' - ' + endDate.format('d/m'));
    for(var i=0; i<7; i++) {
      config.items[i+1].title += (' ' + startDate.add(Date.DAY, i).format('d/m'));
    }
  }
  for(var i=this.startHour; i<=this.endHour; i++) {
    config.items.push({width: 40, title: i+':00'});
    for(var j=0; j<7; j++) {
      config.items.push({html: '&nbsp;'});
    }
  }
  Panel.superclass.constructor.call(this, config)
}

Ext.extend(Ext.ux.tournament.SchedulesPanel, Ext.Panel, {
  includes: function(d) {
    with(this) {
      return startDate <= d && endDate >= d;
    }
  }
});
