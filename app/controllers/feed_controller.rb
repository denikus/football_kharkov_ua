# -*- encoding : utf-8 -*-
class FeedController < ApplicationController
  def index
    @posts = Post.paginate :page => 1, :per_page => 10, :order => 'created_at DESC'
    @feed = {:title => "Основная лента"}
    render :layout=>false, :template => "feed/index.xml.builder"
  end
end
