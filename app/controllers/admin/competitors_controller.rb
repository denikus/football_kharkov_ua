# -*- encoding : utf-8 -*-
class Admin::CompetitorsController < ApplicationController
  def index
    match = Match.find(params[:match_id], :include => {:competitors => [:team, {:football_players => :footballer}]})
    result = [:hosts, :guests].collect do |com|
      competitor = match.send com
      {
        :competitor_id => competitor.id,
        :side => com,
        :team_name => competitor.team.name,
        :score => competitor.score,
        :fouls => competitor.fouls,
        :footballers => competitor.football_players.collect do |fp|
          {:football_player_id => fp.id, :name => "(#{fp.number}) #{fp.footballer.full_name}"}
        end
      }
    end
    
    render :json => result.to_json
  end
end
