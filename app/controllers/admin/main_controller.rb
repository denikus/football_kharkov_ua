class Admin::MainController < ApplicationController
  layout 'admin/main'
  
  before_filter :authenticate_admin!
  
  def index
    render :text => "Hello, #{current_admin.full_name}", :layout => 'admin/main'
  end
end
