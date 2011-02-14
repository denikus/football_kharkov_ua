Ext.ns('Ext.ux.tournament.schedules');

Ext.ux.tournament.schedules.Panel = function Panel(options) {
  var config = {
    id: 'tournament-schedules-panel',
    title: 'Расписание: ',
    layout: 'table',
    layoutConfig: {columns: 8},
    defaults: {width: 150, height: 27},
    items: [this.addBtn(), {title: 'Воскресенье'}, {title: 'Понедельник'}, {title: 'Вторник'}, {title: 'Среда'}, {title: 'Четверг'}, {title: 'Пятница'}, {title: 'Суббота'}]
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
  for(var hour=this.startHour; hour<=this.endHour; hour++) {
    config.items.push({width: 40, title: hour+':00'});
    for(var day=0; day<7; day++) {
      var schedules = [];
      for(var i=0; i<this.schedules[day].length; i++) {
        if(hour == parseInt(this.schedules[day][i].time)) {
          schedules.push(this.schedules[day][i]);
        }
      }
      config.items.push(schedules.length ? new Ext.ux.tournament.schedules.Item(schedules) : Ext.ux.tournament.schedules.Item.EMPTY);
    }
  }
  Panel.superclass.constructor.call(this, config)
}

Ext.extend(Ext.ux.tournament.schedules.Panel, Ext.Panel, {
  includes: function(d) {
    with(this) {
      return startDate <= d && endDate >= d;
    }
  },
  getFormOptions: function() {
    return {
      tournament: this.tournament,
      startDate: this.startDate,
      endDate: this.endDate,
      startHour: this.startHour,
      endHour: this.endHour
    }
  },
  addBtn: function() {
    var self = this;
    return {
      xtype: 'button',
      iconCls: 'icon-add',
      width: 40,
      handler: function(b, e) {
        var editor = new Ext.ux.tournament.schedules.Editor(self.getFormOptions());
        editor.show();
      }
    }
  }
});

Ext.ux.tournament.schedules.Item = function Item(schedules) {
  this.schedules = schedules;
  var config = {
    width: 148,
    height: 25
  }
  Item.superclass.constructor.call(this, config);
  this.updateText();
  this.updateHandler();
}
Ext.extend(Ext.ux.tournament.schedules.Item, Ext.Button, {
  single: function() {
    return this.schedules.length == 1;
  },
  getSchedule: function(i) {
    if(typeof i == 'undefined' || i === null) i = 0;
    return this.schedules[i];
  },
  updateText: function() {
    if(this.single()) {
      with(this.getSchedule()) var text = [time, hosts.substring(0, 10), '-', guests.substring(0, 10)].join(' ');
    } else {
      var text = this.schedules.map(function(s){ return s.time }).join(' | ');
    }
    return this.setText(text);
  },
  updateHandler: function() {
    return this.setHandler(this.single() ? this.singularHandler : this.multipleHandler);
  },
  singularHandler: function(b, e) {
    var editor = new Ext.ux.tournament.schedules.Editor(this.getSchedule());
    editor.show();
  },
  multipleHandler: function(b, e) {
    
  }
});
Ext.ux.tournament.schedules.Item.EMPTY = {html: '&nbsp;'};

Ext.ux.tournament.schedules.Editor = function Window(options) {
  var config = {
    title: 'Новые Данные',
    width: 500,
    height: 300,
    resizable: false,
    layout: 'fit',
    plain: true,
    bodyStyle: 'padding: 5px',
    buttonAlign: 'right',
    modal: true,
    items: new Ext.ux.tournament.schedules.Form(options)
  }
  Window.superclass.constructor.call(this, config);
  this.show();
}
Ext.extend(Ext.ux.tournament.schedules.Editor, Ext.Window);

Ext.ux.tournament.schedules.Form = function Form(options) {
  var config = {
    frame: true,
    layout: 'form',
    url: '/admin/schedules',
    id: 'schedule-form',
    items: [
      new Form.TourSelector(options.tournament),
      new Form.TeamSelector('hosts'),
      new Form.TeamSelector('guests'),
      new Form.DatePicker(options.startDate, options.endDate),
      new Form.TimeInput(options.startHour, options.endHour),
      new Form.VenueSelector
    ]
  }
  Form.superclass.constructor.call(this, config);
  var self = this;
  this.on('render', function() {
    app.mask.show();
    Ext.Ajax.request({
      url: '/admin/schedules/data?what=form&tournament_id='+options.tournament.id,
      success: function(response) {
        self.formData = JSON.parse(response.responseText).data;
        app.mask.hide();
        with(self.formData.last) {
          if(tour_id && stage_id && season_id) self.selectTour(tour_id, season_id, tour_name);
        }
        Ext.getCmp('schedule-form-venue-selector').setVenues(self.formData.venues);
      }
    })
  })
}
Ext.extend(Ext.ux.tournament.schedules.Form, Ext.FormPanel, {
  load: function() {
    Ext.ux.tournament.schedules.Form.superclass.prototype.load.call(this, {
    });
  },
  selectTour: function(tour_id, season_id, tour_name) {
    Ext.getCmp('schedule-form-tour').setValue(tour_name);
    Ext.getCmp('schedule-form-tour').hiddenField.value = tour_id;
    var selector = Ext.getCmp('schedule-form-team-selector-hosts');
    var store = selector.getStore();
    var teams = [], sid = season_id + '';
    store.removeAll();
    for(var i=0, l=this.formData.teams.length; i<l; i++) {
      var team = this.formData.teams[i];
      if(sid in team.steps) {
        teams.push(new store.recordType({
          teamId: team.id,
          teamName: team.name,
          leagueId: team.steps[sid]
        }));
      }
    }
    if(teams.length > 0) {
      store.add(teams);
      selector.enable();
    } else {
       selector.disable();
    }
  }
});

Ext.ux.tournament.schedules.Form.TourSelector = function Selector(tournament) {
  var config = {
    store: new Ext.data.SimpleStore({fields:[], data: [[]]}),
    id: 'schedule-form-tour',
    hiddenName: 'step_tour_id',
    hiddenValue: '',
    fieldLabel: 'Тур',
    editable: false,
    shadow: false,
    mode: 'local',
    maxHeight: 200,
    tpl: '<tpl for="."><div style="height:200px"><div id="tour_selector_tree"></div></div></tpl>',
    selectedClass: ''
  }
  Selector.superclass.constructor.call(this, config);
  var self = this;
  this.tree = new Ext.tree.TreePanel({
    dataUrl:'/admin/schedules/data?what=tour_tree&tournament_id='+tournament.id,
    border: false,
    containerScroll: true,
    autoScroll: true,
    root: new Ext.tree.AsyncTreeNode({text: tournament.name + ': Выбор Тура', expanded: true, id: 'root'})
  });
  this.tree.on('click', function(node){
    if(node.leaf) {
      self.setValue(node.text);
      self.hiddenField.value = node.attributes._id;
      self.treeAction = false;
      Ext.getCmp('schedule-form').selectTour(node.attributes._id, node.parentNode.parentNode.attributes._id)
    } else {
      self.treeAction = true;
    }
  });
  this.tree.on('beforeexpandnode', function(){ self.treeAction = true });
  this.tree.on('beforecollapsenode', function(){ self.treeAction = true });
  this.on('expand', function() {
    this.tree.render('tour_selector_tree');
  });
  this.on('collapse', function() {
    if(this.treeAction) {
      this.expand();
      this.treeAction = false;
    }
  })
}
Ext.extend(Ext.ux.tournament.schedules.Form.TourSelector, Ext.form.ComboBox);

Ext.ux.tournament.schedules.Form.TeamSelector = function Selector(side) {
  var store = new Ext.data.ArrayStore({
    id: 0,
    fields: ['teamId', 'teamName', 'leagueId'],
    data: []
  })
  var config = {
    id: 'schedule-form-team-selector-' + side,
    disabled: true,
    fieldLabel: side == 'hosts' ? 'Хозяева' : 'Гости',
    lazyRender:true,
    typeAhead: true,
    mode: 'local',
    name: side + '_team_id',
    valueField: 'teamId',
    displayField: 'teamName',
    store: store,
    listeners: {
      select: function(combo, record, index) {
        if(side == 'hosts') {
          var form = Ext.getCmp('schedule-form');
          var guests = Ext.getCmp('schedule-form-team-selector-guests');
          var gstore = guests.getStore();
          if(record.data.leagueId) {
            var items = _(form.formData.teams).chain()
              .select(function(t){ return _.any(t.steps, function(l){ return l == record.data.leagueId }) && t.id != record.data.teamId})
              .map(function(t) {
                return new gstore.recordType({
                  teamId: t.id,
                  teamName: t.name,
                  leagueId: record.data.leagueId
                })
              }).value();
            items.length ? gstore.add(items) : cloneStore(combo.getStore(), gstore);
          } else {
            cloneStore(combo.getStore(), gstore);
          }
          guests.enable();
        }
        
        function cloneStore(source, dest) {
          var items = [];
          for(var i=0, l=source.getCount(); i<l; i++) {
            var item = source.getAt(i).data;
            items.push(new source.recordType({
              teamId: item.teamId,
              teamName: item.teamName,
              leagueId: item.leagueId
            }));
          }
          dest.add(items);
        }
      }
    }
  };
  
  Selector.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.tournament.schedules.Form.TeamSelector, Ext.form.ComboBox);

Ext.ux.tournament.schedules.Form.DatePicker = function Picker(startDate, endDate) {
  var config = {
    allowBlank: false,
    fieldLabel: 'Дата',
    name: 'match_on',
    format: 'Y-m-d',
    minValue: startDate,
    maxValue: endDate
  }
  Picker.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.tournament.schedules.Form.DatePicker, Ext.form.DateField)

Ext.ux.tournament.schedules.Form.TimeInput = function Input(startHour, endHour) {
  var config = {
    allowBlank: false,
    name: 'match_at',
    fieldLabel: 'Время',
    format: 'H:i',
    minValue: (startHour < 10 ? '0' : '') + startHour + ':00',
    maxValue: (endHour < 10 ? '0' : '') + endHour + ':30',
    increment: 30
  }
  Input.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.tournament.schedules.Form.TimeInput, Ext.form.TimeField);

Ext.ux.tournament.schedules.Form.VenueSelector = function Selector() {
  var store = new Ext.data.ArrayStore({
    id: 0,
    fields: ['venueId', 'venueName'],
    data: []
  })
  var config = {
    id: 'schedule-form-venue-selector',
    fieldLabel: 'Место',
    lazyRender: true,
    typeAhead: true,
    mode: 'local',
    name: 'venue_id',
    valueField: 'venueId',
    displayField: 'venueName',
    store: store
  };
  
  Selector.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.tournament.schedules.Form.VenueSelector, Ext.form.ComboBox, {
  setVenues: function(venues) {
    var store = this.getStore();
    var items = _.map(venues, function(v) {
      return new store.recordType({
        venueId: v.id,
        venueName: v.name
      })
    });
    store.add(items);
  }
});