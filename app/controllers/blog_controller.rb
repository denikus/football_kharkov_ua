class BlogController < ApplicationController
#  include ActionController::UrlWriter
#  default_url_options[:host] = 'localhost:3000'
#  layout 'application'
  def index
    params[:page] = 1 if !params[:page]
    @posts = Post.paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
  end
 
end
