Ext.ns('Ext.ux', 'Ext.ux.menu');

Ext.ux.menu.TournamentsMenu = function Menu(tournaments) {
  var config = {
    id: 'menu-tournaments',
    items: tournaments.map(function(t) {
      return {text: t.name, handler: Menu.handler, attrs: t}
    })
  }
  Menu.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.menu.TournamentsMenu, Ext.menu.Menu);
Ext.ux.menu.TournamentsMenu.handler = function(item) {
  app.removeAll();
  app.nav.items.add(new Ext.ux.nav.Tournament(item.attrs));
  app.nav.doLayout();
}

Ext.ux.Menu = function Bar(options) {
  var config = {
    renderTo: 'app-toolbar',
    items: ['Административная панель', '-',
      {
        text: 'Чемпионаты',
        menu: new Ext.ux.menu.TournamentsMenu(options.tournaments)
      }
    ]
  }
  Bar.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.Menu, Ext.Toolbar)
