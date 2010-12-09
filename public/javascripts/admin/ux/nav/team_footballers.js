Ext.ns('Ext.ux.nav');
Ext.ux.nav.TeamFootballers = function Panel() {
  var config = {
    height: 350,
    region: 'center',
    useArrows: true,
    autoScroll: true,
    animate: true,
    containerScroll: true,
    border: false,
    dataUrl: '/admin/tournaments.json',
    requestMethod: 'GET',
    id: 'nav-team-footballers',
    root: {
      expanded: true,
      id: "nav-team-footballers-root"
    },
    rootVisible: false,
    disabled: true,
    listeners: {
      click: this.nodeClick
    }
  }
  Panel.superclass.constructor.call(this, config);
}

Ext.extend(Ext.ux.nav.TeamFootballers, Ext.tree.TreePanel, {
  nodeClick: function(node) {
    if(node.attributes.step_id) {
      app.details.removeAll(true);
      var team_id = Ext.getCmp('personnel-form').personnel_id;
      app.details.items.add(new Ext.ux.personnel.TeamFootballersPanel(team_id, node.attributes.step_id));
      app.details.doLayout();
    }
  }
});
