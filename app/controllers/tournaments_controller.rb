class TournamentsController < ApplicationController
  def index
    params[:page] = 1 if !params[:page]
    @posts = Post.tournament(current_subdomain).paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
  end

  def feed
    tournament = Tournament.find_by_url(current_subdomain)
    @posts = Post.tournament(current_subdomain).paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
    @feed = {:title => tournament.name}
    render :layout=>false, :template => "feed/index"
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
end
