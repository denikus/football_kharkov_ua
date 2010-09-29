class Admin::StatsController < ApplicationController
  def index
  end
  
  def show
    if params[:match_id] == 'new'
      render :update do |page|
        if params[:team_id].empty?
          page['match_'+params[:side]+'_stats'].replace_html ''
        else
          team = Team.find params[:team_id]
          team.season_id = params[:season_id]
          page['match_'+params[:side]+'_stats'].replace_html :partial => 'new_match', :locals => {:team => team, :side => params[:side]}
        end
      end
    end
    #if params[:match_id]
    #  match = Match.find(params[:match_id], :include => {:competitors => [:stats, {:football_players => [:footballer, :stats]}]})
    #  render :json => match.stats.to_json
    #end
  end
  
  def update
    if params[:match_id]
      match = Match.find(params[:match_id], :include => {:competitors => [:stats, {:football_players => :stats}]})
      Competitor::SIDES.each{ |s| match.send(s).update_stats(params[s]) }
      
      render :json => {:success => true}
    end
  end
end
