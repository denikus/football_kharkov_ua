class BlogController < ApplicationController
  def index
    params[:page] = 1 if !params[:page] 
    @posts = Post.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
  end
 
end
