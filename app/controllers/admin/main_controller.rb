class Admin::MainController < ApplicationController
  before_filter :authenticate_admin!
  
  def index
    render :text => "Hello, #{current_admin.full_name}", :layout => ['admin/main', params[:format]].compact.join('_')
  end
end
