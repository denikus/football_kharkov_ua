class Admin::StatsController < ApplicationController
  def index
  end
  
  def show
    if params[:match_id]
      match = Match.find(params[:match_id], :include => {:competitors => [:stats, {:football_players => [:footballer, :stats]}]})
      render :json => match.stats.to_json
    end
  end
  
  def update
    if params[:match_id]
      match = Match.find(params[:match_id], :include => {:competitors => [:stats, {:football_players => :stats}]})
      Competitor::SIDES.each{ |s| match.send(s).update_stats(params[s]) }
      
      render :json => {:success => true}
    end
  end
end
