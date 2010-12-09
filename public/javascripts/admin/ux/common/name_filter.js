Ext.ns('Ext.ux.common');
Ext.ux.common.NameFilter = function Filter(store) {
  var timeout = 0, self = this;
  var config = {
    width: 200,
    emptyText: 'Фильтр',
    enableKeyEvents: true,
    listeners: {
      keyup: function() {
        if(timeout) clearTimeout(timeout);
        timeout = setTimeout(function() {
          store.filter('name', self.getValue(), true, false);
          timeout = 0;
        }, 300);
      },
      scope: this
    }
  }
  Filter.superclass.constructor.call(this, config);
}
Ext.extend(Ext.ux.common.NameFilter, Ext.form.TextField);
