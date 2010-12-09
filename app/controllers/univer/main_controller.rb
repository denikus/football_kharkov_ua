class Univer::MainController < ApplicationController
  before_filter :authenticate_admin!

  def index
    render :text => "Hello, #{current_admin.full_name}", :layout => ['univer/application', params[:format]].compact.join('_')
  end
end
