Ext.ns('Ext.ux.layout');
Ext.ux.layout.MasterPanel = function Panel() {
  var config = {
    title: 'Master',
    region: 'center',
    id: 'master-panel',
    autoScroll: true
  }
  Panel.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.layout.MasterPanel, Ext.Panel);

Ext.ux.layout.DetailsPanel = function Panel() {
  var config = {
    id: 'details-panel',
    title: 'Details',
    region: 'south',
    collapsible: true,
    collapsed: true,
    split: true,
    height: 300
  }
  Panel.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.layout.DetailsPanel, Ext.Panel);

Ext.ux.layout.MainPanel = function Panel() {
  var config = {
    layout: 'border',
    region: 'center',
    collapsible: false,
    border: false,
    margins: '5 5 5 0',
    id: 'main-view',
    hideMode: 'offsets',
    items: [
      new Ext.ux.layout.MasterPanel(),
      new Ext.ux.layout.DetailsPanel()
    ]
  };
  Panel.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.layout.MainPanel, Ext.Panel);

Ext.ux.layout.NavPanel = function Panel() {
  var config = {
    id: 'nav-panel',
    title: 'Navigation',
    region: 'west',
    margins: '5 0 5 5',
    cmargins: '5 5 5 5',
    layout: 'fit',
    width: 200,
    minSize: 100,
    maxSize: 300
  };
  Panel.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.layout.NavPanel, Ext.Panel);

Ext.ux.layout.App = function App() {
  var config = {
    layout: 'border',
    defaults: {
      collapsible: false,
      split: true
    },
    items: [
      {xtype: 'box', el: 'app-toolbar', region: 'north'},
      new Ext.ux.layout.NavPanel(),
      new Ext.ux.layout.MainPanel()
    ]
  }
  App.superclass.constructor.call(this, config);
  
  this.nav = Ext.getCmp('nav-panel');
  this.master = Ext.getCmp('master-panel');
  this.details = Ext.getCmp('details-panel');
  
  this.removeAll = function(destroy) {
    this.nav.removeAll(destroy);
    this.master.removeAll(destroy);
    this.details.removeAll(destroy);
  }
  
  this.mask = new Ext.LoadMask(Ext.getBody(), {
    msg: "Загрузка данных..."
  });
}
Ext.extend(Ext.ux.layout.App, Ext.Viewport);
