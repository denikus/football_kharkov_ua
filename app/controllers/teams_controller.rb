class TeamsController < ApplicationController
  layout "app_without_sidebar"
  
  def index
    unless current_subdomain.nil?
      tournament = Tournament.find_by_url(current_subdomain)
      last_season = StepSeason.where(:tournament_id => tournament.id).order("identifier ASC").last

      @teams_by_groups = []
      last_season.stages.first.leagues.order("identifier ASC").each do |league|
        @teams_by_groups << {:league_name  => league.name, :teams => league.teams}
      end


#      @teams = Team.find(:all,
#                          :joins => "INNER JOIN `steps_teams` " +
#                                      "ON (teams.id = steps_teams.team_id) " +
#                                    "INNER JOIN `steps` " +
#                                      "ON (steps_teams.step_id = steps.id AND type = 'StepSeason')",
#                          :conditions => ["tournament_id = ? ", tournament.id],
#                          :order => "teams.name ASC"
#                        )
      
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
      if @team.nil? 
        render "#{Rails.root}/public/404.html", :status => 404, :layout => false
        return
      end
      
      @tournament = Tournament.find_by_url(current_subdomain)
      @season = StepSeason.find(:last,
                                 :joins => "INNER JOIN `steps_teams` ON (steps.id = steps_teams.step_id) ",
                                 :conditions => ["steps_teams.team_id = ? AND steps.tournament_id = ? ", @team.id, @tournament.id]
                                 # :order => "steps."
                                )
#      @team.seasons.by_tournament(@tournament.id)
      @footballers = Footballer.by_team_step({:team_id => @team.id, :step_id => @season.id} )
      @schedules = Schedule.future_team_matches(@team.id)
    end
  end
end
