# -*- encoding : utf-8 -*-
class FeedController < ApplicationController
  def index
    #respond_to do |format|
    #  format.xml do
        @posts = Post.paginate :page => 1, :per_page => 10, :order => 'created_at DESC'
        @feed = {:title => "Основная лента"}
        render :layout=>false, :template => "feed/index.xml.builder"
        #response.headers["Content-Type"] = "application/xml; charset=utf-8"
      #end
    #end
  end
end
