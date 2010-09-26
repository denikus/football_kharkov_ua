ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  # See how all your routes lay out with "rake routes"

#  map.cms ":cmspage",
#          :controller => "page",
#          :action => "show",
#          :requirements => { :cmspage => /[a-zA-Z0-9_]+(\.htm)/,}

#  devise_for :users

#  map.tournament '', :controller => "tournaments", :action => "index", :conditions => {:subdomain => /.+/}

  map.devise_for :users, :admin
  map.namespace(:admin) do |admin|
    admin.root :controller => 'main'
    admin.ext_root '.ext', :controller => :main, :format => :ext
    admin.resources :comments
    admin.resources :tournaments, :collection => {:grid_edit => :post} do |t|
      t.resources :seasons, :collection => {:grid_edit => :post}
      t.resources :matches, :collection => {:grid_edit => :post}
      t.resources :teams, :collection => {:team_2_season => :get}
      t.resources :schedules
    end
    admin.resources :schedules
    admin.resources :seasons, :has_many => [:teams] do |s|
      s.resources :stages, :collection => {:grid_edit => :post}
      s.resources :leagues, :collection => {:grid_edit => :post}
      s.resources :tours, :collection => {:grid_edit => :post}
    end
    admin.resources :stages, :has_many => :leagues, :collection => {:grid_edit => :post}
    admin.resources :leagues, :has_many => [:teams, :tours], :collection => {:grid_edit => :post}
    admin.resources :teams, :has_many => [:leagues, :footballers], :collection => {:grid_edit => :post}
    admin.resources :tours, :has_many => :matches, :collection => {:grid_edit => :post}
    admin.resources :matches do |m|
      m.resources :competitors
      m.resource :stats
    end
    admin.resources :match_events
    admin.resources :match_event_types, :collection => {:grid_edit => :post}
    admin.resources :referees, :collection => {:grid_edit => :post}
    admin.resources :footballers
    admin.resources :permissions
    admin.resources :venues
  end
  
#  map.devise_for :users
  
  map.resources :users
  map.resources :pages
  map.resource :profile, :collection => {:edit_photo => :get, :upload_photo => :post, :crop => :get, :destroy_photo => :delete, :make_crop => :post}
  map.resource :itleague_draw
  map.resources :footballers, :only => ["index", "show"]

  map.with_options :conditions => {:subdomain => /.+/} do |tournament|
    tournament.tournament 'feed', :controller => "tournaments", :action => "feed" #, :conditions => {:subdomain => /.+/}
    tournament.tournament '', :controller => "tournaments", :action => "index" #, :conditions => {:subdomain => /.+/}
    tournament.post 'post', :controller=>'post', :action=>'show', :requirements=> {:year=> /\d{4}/, :month=>/\d{1,2}/, :day=>/\d{1,2}/}
    tournament.resources :teams, :only => ["index", "show"]
  end


  map.root :controller => "blog"

#  map.subdomain_post ':year/:month/:day/:url',
#    :controller=>'post',
#    :action=>'show',
#    :requirements=> {:year=> /\d{4}/, :month=>/\d{1,2}/, :day=>/\d{1,2}/},
#    :conditions => {:subdomain => /.+/}
  
  map.post ':year/:month/:day/:url',
    :controller=>'post',
    :action=>'show',
    :requirements=> {:year=> /\d{4}/, :month=>/\d{1,2}/, :day=>/\d{1,2}/}


  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  #user area
  #map.username "/:username/:action",
  #  :controller => 'profile'
end
