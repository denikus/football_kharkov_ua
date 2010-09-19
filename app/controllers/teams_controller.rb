class TeamsController < ApplicationController
  layout "app_without_sidebar"
  
  def index
    unless current_subdomain.nil?
      @teams = Tournament.find_by_url(current_subdomain).seasons.last.teams.find(:all, :order => "name ASC")
    end
  end

  def show
    unless current_subdomain.nil?
      @team = Team.find_by_url(params[:id])
      @tournament = Tournament.find_by_url(current_subdomain)
      @seasons = @team.seasons.by_tournament(@tournament.id)
      @footballers = Footballer.by_team_season({:team_id => @team.id, :season_id => @seasons.last.id} )

    end
  end
end
