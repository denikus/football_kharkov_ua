Ext.namespace("Application.Menu");
Application.Menu = Ext.extend(Ext.tree.TreePanel, {
     constructor: function(config){
       // Нам очень редко придётся использовать сам конструктор, так что этот метод можно и вовсе
       // опустить, если мы не хотим сделать что-то с конфигурацией ещё до того, как она попадёт
       // в базовый конструктор. Но иметь представление о том, что функция конструктора всё же есть - надо.

       // Нельзя забывать вызывать базовый метод, если таковой имеется
       Application.Menu.superclass.constructor.apply(this, arguments);
   }
   ,initComponent: function() {
       // А вот этот метод очень важен. Инициализация компонента вызывается после конструктора.
       // А потому переопределённая конфигурация приоритетнее конфигурации, заданной пользователем
       // в конструкторе. В нём мы и будем переопределять конфигурацию объекта.

       // Копируем с заменой все свойства второго аргумента в первый. Что бы там пользователь
       // в конструкторе для свойств ни определил, если эти свойства будут во втором аргументе - они
       // заменят собой свойства в нашем объекте
       Ext.apply(this, {
         root: new Ext.tree.AsyncTreeNode({
            expanded: true
           ,children: [
              {
                text: 'Контент'
               ,leaf: false
               ,icon: '/images/icons/page_white_text.png'
               ,expanded: true
               ,children:[{
                  id: 'application-menu-comment-node'
                 ,text: 'Комментарии'
                 ,leaf: true
                 ,cls: 'application-menu-node'
                 ,icon: '/images/icons/comments.png'
                }
                , {
                  id: 'application-menu-tournament-node'
                 ,text: 'Турниры'
                 ,leaf: true
                 ,cls: 'application-menu-node'
                 ,icon: '/images/icons/sitemap_color.png'
                }
                , {
                  id: 'application-menu-season-node'
                 ,text: 'Сезоны'
                 ,leaf: true
                 ,cls: 'application-menu-node'
//                 ,icon: '/images/icons/sitemap_color.png'
                }
                , {
                  id: 'application-menu-stage-node'
                 ,text: 'Этапы'
                 ,leaf: true
                 ,cls: 'application-menu-node'
//                 ,icon: '/images/icons/sitemap_color.png'
                }
                , {
                  id: 'application-menu-league-node'
                 ,text: 'Лиги'
                 ,leaf: true
                 ,cls: 'application-menu-node'
//                 ,icon: '/images/icons/sitemap_color.png'
                }
                , {
                  id: 'application-menu-team-node'
                 ,text: 'Команды'
                 ,leaf: true
                 ,cls: 'application-menu-node'
                 ,icon: '/images/icons/group.png'
                }
                , {
                  id: 'application-menu-footballer-node'
                 ,text: 'Игроки'
                 ,leaf: true
                 ,cls: 'application-menu-node'
                 ,icon: '/images/icons/user.png'
                }
                , {
                  id: 'application-menu-teams-footballers-node'
                 ,text: 'Игроки в командах'
                 ,leaf: true
                 ,cls: 'application-menu-node'
                 ,icon: '/images/icons/sitemap_color.png'
                }
                , {
                  id: 'application-menu-league-teams-node'
                 ,text: 'Участие команд'
                 ,leaf: true
                 ,cls: 'application-menu-node'
                 ,icon: '/images/icons/sitemap_color.png'
                }
                , {
                  id: 'application-menu-matches-node'
                 ,text: 'Матчи'
                 ,leaf: true
                 ,cls: 'application-menu-node'
                }
              ]
              }
/*              , {
                text: 'Menu Option 2',
                leaf: true
            }, {
                text: 'Menu Option 3',
                leaf: true
            }*/
            ,{
                text: 'Администрация'
               ,leaf: false
               ,icon: '/images/icons/man.png'
               ,expanded: true
               ,children:[{
                  id: 'application-menu-permission-node'
                 ,text: 'Права'
                 ,leaf: true
                 ,cls: 'application-menu-node'
                 ,icon: '/images/icons/pencil.png'
                }]
            }
            ]
        })
        ,rootVisible: false
        ,padding: '5px 0px 0px 0px'
       });

       // Не забываем вызывать базовый метод инициализации
       Application.Menu.superclass.initComponent.apply(this, arguments);
   }
  ,listeners:
  {
    'click': function(e, t) {
      var main_panel = Ext.getCmp('main-panel-tab-content');
      return function(eid, type){
         if (eid==e['id'] && (main_panel.items.length==0 || main_panel.items.first()['xtype'] != type) ) {
            if (main_panel.items.length > 0 && main_panel.items.first()['xtype'] != type) {
              main_panel.removeAll();
              main_panel.doLayout();
            }
            main_panel.add({xtype: type});
            main_panel.doLayout();
         }
         return false;
      }(e['id'], function(){
         switch(e['id']) {
            case 'application-menu-comment-node': return 'commentgrid';
            case 'application-menu-tournament-node': return 'tournamentgrid';
            case 'application-menu-season-node': return 'seasongrid';
            case 'application-menu-stage-node': return 'stagegrid';
            case 'application-menu-league-node': return 'leaguegrid';
            case 'application-menu-team-node': return 'teamgrid';
            case 'application-menu-footballer-node': return 'footballergrid';
            case 'application-menu-permission-node': return 'permissiontree';
            case 'application-menu-league-teams-node': return 'leagueteamsform';
            case 'application-menu-teams-footballers-node': return 'teamfootballersform';
            case 'application-menu-matches-node': return 'matchespanel';
            default: return false;
         }
         return false;
      }());
    }
  }
});
Ext.reg("applicationmenu", Application.Menu);