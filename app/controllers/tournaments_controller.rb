# -*- encoding : utf-8 -*-
class TournamentsController < ApplicationController

  def index
    params[:page] ||= 1
    @posts = Post.tournament(request.subdomain).order('created_at DESC').page(params[:page]).per_page(10)
  end

  def feed
    tournament = Tournament.find_by_url(request.subdomain)
    @posts = Post.tournament(request.subdomain).paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
    @feed = {:title => tournament.name}
    render :layout=>false, :template => "feed/index"
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end

end
