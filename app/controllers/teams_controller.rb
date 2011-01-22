class TeamsController < ApplicationController
  layout "app_without_sidebar"
  
  def index
    unless current_subdomain.nil?
      tournament = Tournament.find_by_url(current_subdomain)
      @teams = Team.find(:all,
                          :joins => "INNER JOIN `steps_teams` " +
                                      "ON (teams.id = steps_teams.team_id) " +
                                    "INNER JOIN `steps` " +
                                      "ON (steps_teams.step_id = steps.id AND type = 'StepSeason')",
                          :conditions => ["tournament_id = ? ", tournament.id],
                          :order => "teams.name ASC"
                        )
#      @teams = StepSeason.find(:last,
#                               :conditions => ["tournament_id = ?", tournament.id],
#                               :order => "name ASC"
#                              )
#      @teams = Tournament.find_by_url(current_subdomain).seasons.last.teams.find(:all, :order => "name ASC")
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
