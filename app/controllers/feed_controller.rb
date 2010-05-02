class FeedController < ApplicationController
  def index
    @posts = Post.paginate :page => 1, :per_page => 10, :order => 'created_at DESC'
    render :layout=>false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
end
