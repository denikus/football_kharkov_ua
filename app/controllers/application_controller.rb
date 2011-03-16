class ApplicationController < ActionController::Base
  include UrlHelper 
  protect_from_forgery

  protected

  def ext_success data={}
    {:json => {:success => true}.merge(data)}
  end

  def ext_failure
    {:json => {:success => false}}
  end
end
