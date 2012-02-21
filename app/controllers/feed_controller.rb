# -*- encoding : utf-8 -*-
class FeedController < ApplicationController
  def index
    request.format = "xml" unless params[:format]
    @posts = Post.paginate :page => 1, :per_page => 10, :order => 'created_at DESC'
    @feed = {:title => "Основная лента"}
    render :layout=>false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
end
