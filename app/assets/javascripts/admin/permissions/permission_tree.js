Ext.namespace("PermissionTree");
PermissionTree = Ext.extend(Ext.tree.TreePanel, {
  initComponent: function() {
    Ext.apply(this, {
      title: 'Управление правами доступа',
      height: 400,
      width: 600,
      useArrows: true,
      autoScroll: true,
      animate: true,
      enableDD: false,
      containerScroll: true,
      rootVisible: false,
      frame: true,
      root: {
        nodeType: 'async'
      },
      // auto create TreeLoader
      requestMethod: 'get',
      dataUrl: '/admin/permissions'
    })
    PermissionTree.superclass.initComponent.apply(this, arguments);
    this.on('checkchange', this.onCheckChange);
  },
  onCheckChange: function(node, checked) {
    method = 'POST'
    if(!checked) method = 'DELETE';
    Ext.Ajax.request({
      method: method,
      url: '/admin/permissions' + (checked ? '' : '/0'),
      params: {
        'permission[admin]': node.parentNode.parentNode.text,
        'permission[controller]': node.parentNode.text,
        'permission[action]': node.text
      }
    });
  },
  onDestroy: function(){
    PermissionTree.superclass.onDestroy.call(this);
  }
});
Ext.reg("permissiontree", PermissionTree);
