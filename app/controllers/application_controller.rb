# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  if RAILS_ENV=="production"
    include ExceptionNotification::Notifiable
  end
  
  helper :all # include all helpers, all the time
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery  #:secret => 'fb69fb1eb9196578d12b757b65155f72'
  #
  ##session :session_key => '_football_session_id'
  #include LoginSystem
  #
  #protected
  #
  #def authorize
  #  unless is_logged_in?
  #    flash[:notice] = 'Чтобы выполнить данное действие - зарегистрируйтесь!'
  #    redirect_to :controller => :post, :action => :index
  #  end
  #end
  protected
  
  def ext_success
    {:json => {:success => true}}
  end
end
