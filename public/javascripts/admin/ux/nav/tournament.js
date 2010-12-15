Ext.ns('Ext.ux.nav');
Ext.ux.nav.Tournament = function Panel(tournament) {
  this.tournament = tournament;
  var config = {
    height: 350,
    region: 'center',
    useArrows: true,
    autoScroll: true,
    animate: true,
    containerScroll: true,
    border: false,
    dataUrl: '/admin/tournaments/' + this.tournament.url + '/steps.ext',
    requestMethod: 'GET',
    id: 'nav-tournament',
    root: {
      nodeType: 'async',
      expanded: true,
      text: 'Сезоны',
      id: "nav-tournament-root"
    },
    listeners: {
      click: this.nodeClick
    },
    tbar: [{
      iconCls: 'icon-expand-all',
      tooltip: 'Открыть последний Тур',
      handler: function(){ this.expandTour() },
      scope: this
    }]
  }
  Panel.superclass.constructor.call(this, config);
}

Ext.extend(Ext.ux.nav.Tournament, Ext.tree.TreePanel, {
  nodeClick: function(node) {
    app.master.removeAll(true);
    app.details.removeAll(true);
    var n = node, caption = [];
    while(!n.isRoot){ caption.unshift(n.text); n = n.parentNode; }
    caption.unshift(app.nav.items.items[0].tournament.name);
    if(node.attributes._type == 'Schedule') {
      app.master.add(new Ext.ux.tournament.MatchForm({
        id: node.attributes._id,
        caption: caption.join(' &gt; '),
        match_id: node.attributes._match_id,
        hosts: node.attributes._hosts,
        guests: node.attributes._guests,
        hosts_footballer_ids: node.attributes._hosts_footballer_ids.split(',').map(function(e){ return parseInt(e) }),
        guests_footballer_ids: node.attributes._guests_footballer_ids.split(',').map(function(e){ return parseInt(e) })
      }));
    } else {
      if(node.attributes._id || node.attributes._type) {
        app.master.add(new Ext.ux.tournament.StepForm({
          caption: caption.join(' &gt; '),
          type: node.attributes._type,
          id: node.attributes._id,
          identifier: node.attributes._identifier,
          name: node.attributes._name,
          url: node.attributes._url,
          parent_id: node.attributes._owner_id,
          tournament_id: app.nav.items.items[0].tournament.id,
          node: node.parentNode
        }));
      }
      if(node.attributes._id && (node.attributes._type == 'StepSeason' || node.attributes._type == 'StepLeague')) {
        app.details.add(new Ext.ux.tournament.StepTeamsPanel(node.attributes._id));
      }
    }
    app.master.doLayout();
    app.details.doLayout();
  },
  expandTour: function() {
    if(!this.expanding) this.expanding = this.root;
    if(!this.expanding.expanded) {
      setTimeout(this.expandTour.createDelegate(this), 100);
    } else {
      if(this.expanding.attributes._type != 'StepTour') {
        var last_index = this.expanding.childNodes.length - 1;
        this.expanding = this.expanding.childNodes[last_index].leaf ? this.expanding.childNodes[last_index-1] : this.expanding.childNodes[last_index];
        this.expanding.expand();
        setTimeout(this.expandTour.createDelegate(this), 100);
      } else {
        delete this.expanding;
      }
    }
  }
});
