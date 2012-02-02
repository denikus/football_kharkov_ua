# -*- encoding : utf-8 -*-
class TournamentsController < ApplicationController
  def index
    params[:page] = 1 if !params[:page]
    @posts = Post.tournament(request.subdomain).paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
  end

  def feed
#    request.subdomain
    tournament = Tournament.find_by_url(request.subdomain)
    @posts = Post.tournament(request.subdomain).paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
    @feed = {:title => tournament.name}
    render :layout=>false, :template => "feed/index"
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
end
