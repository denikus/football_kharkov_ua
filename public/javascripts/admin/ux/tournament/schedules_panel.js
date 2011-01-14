Ext.ns('Ext.ux.tournament');

Ext.ux.tournament.SchedulesPanel = function Panel(options) {
  var config = {
    title: 'Расписание',
    layout: 'table',
    layoutConfig: {columns: 8},
    defaults: {width: 150, height: 20},
    items: [{width: 40, title: '&nbsp;'}, {title: 'Воскресенье'}, {title: 'Понедельник'}, {title: 'Вторник'}, {title: 'Среда'}, {title: 'Четверг'}, {title: 'Пятница'}, {title: 'Суббота'}]
  }
  Ext.apply(this, options);
  for(var i=this.startHour; i<=this.endHour; i++) {
    config.items.push({width: 40, title: i+':00'});
    for(var j=0; j<7; j++) {
      config.items.push({html: '&nbsp;'});
    }
  }
  Panel.superclass.constructor.call(this, config)
}

Ext.extend(Ext.ux.tournament.SchedulesPanel, Ext.Panel);
