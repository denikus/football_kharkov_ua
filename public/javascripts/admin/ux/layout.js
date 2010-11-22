Ext.ns('Ext.ux.layout');
Ext.ux.layout.MasterPanel = function Panel() {
  var config = {
    title: 'Master',
    region: 'center',
    id: 'master-panel',
    tbar: [{
      split: true,
      text: 'Details Panel',
      id: 'details-panel-button',
      handler: this.toggleDetails.createDelegate(this, []),
      menu: {
        id: 'details-menu',
        cls: 'details-menu',
        width: 100,
        items: [{
          text: 'Bottom',
          checked: true,
          group: 'rp-group',
          checkHandler: this.toggleDetails,
          scope: this,
          iconCls: 'details-bottom'
        }, {
          text: 'Right',
          checked: false,
          group: 'rp-group',
          checkHandler: this.toggleDetails,
          scope: this,
          iconCls: 'details-right'
        }, {
          text: 'Hide',
          checked: false,
          group: 'rp-group',
          checkHandler: this.toggleDetails,
          scope: this,
          iconCls: 'details-hide'
        }]
      }
    }]
  }
  Panel.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.layout.MasterPanel, Ext.Panel, {
  toggleDetails: function(m, pressed) {
    if(!m) {
      var readMenu=Ext.menu.MenuMgr.get('details-menu');
      readMenu.render();
      var items=readMenu.items.items;
      var b=items[0], r=items[1], h=items[2];
      if (b.checked) {
        r.setChecked(true);
      } else if (r.checked) {
        h.setChecked(true);
      } else if (h.checked) {
        b.setChecked(true);
      }
      return;
    }
    if (pressed) {
      var details=Ext.getCmp('details-panel');
      var right=Ext.getCmp('right-details');
      var bot=Ext.getCmp('bottom-details');
      switch (m.text) {
        case 'Bottom':
          right.hide(); 
          right.remove(details, false);
          bot.add(details);
          bot.show();
          bot.ownerCt.doLayout();
          break;
        case 'Right':
          bot.hide(); 
          bot.remove(details, false);
          right.add(details);
          right.show();
          right.ownerCt.doLayout();
          break;
        case 'Hide':
          bot.hide();
          right.hide(); 
          right.remove(details, false); 
          bot.remove(details, false);
          right.ownerCt.doLayout();
          break;
      }
    }
  }
});

Ext.ux.layout.DetailsPanel = function Panel() {
  var config = {
    id: 'details-panel',
    title: 'Details',
    layout: 'fit'
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
      {
        id: 'bottom-details',
        layout: 'fit',
        height: 300,
        split: true,
        border: false,
        region: 'south',
        items: new Ext.ux.layout.DetailsPanel()
      }, {
        id: 'right-details',
        layout: 'fit',
        border: false,
        region: 'east',
        width: 350,
        split: true,
        hidden: true
    }]
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
}
Ext.extend(Ext.ux.layout.App, Ext.Viewport);
