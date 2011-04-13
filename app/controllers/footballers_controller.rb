class FootballersController < ApplicationController
  layout "app_without_sidebar"
  
  def show
    @footballer = Footballer.find_by_url(params[:id])


    tournaments = @footballer.footballers_teams.joins(:step).group("steps.tournament_id").collect{|item| item.step.tournament}

    @tournaments_teams = []
    tournaments.each do |tournament|
      last_season_team = @footballer.footballers_teams.joins(:step).where('steps.tournament_id = ?', tournament.id).order("identifier ASC").last
      matches = []
      last_season_team.step.stages.collect{|stage| stage.tours.map{|tour| tour.schedules.map{|schedule| matches << schedule.match if (!schedule.host_scores.nil? && (schedule.host_team_id == last_season_team.team.id || schedule.guest_team_id == last_season_team.team.id)) }}}
      @tournaments_teams << {
                             :tournament => tournament,
                             :season => last_season_team.step,
                             :team => last_season_team.team,
                             :league =>  last_season_team.team.get_league(@footballer.id, last_season_team.step.id),
                             :total_team_matches => matches.count,
                             :footballer_matches => Match.played_by_footballer(matches.collect{|m| m.id}, last_season_team.team.id, @footballer.id).count
                            }
    end


#    ap @footballer.footballers_teams.joins(:step).group("steps.tournament_id").to_sql
    
#    @footballer.footballers_teams
#    @tournaments_take_part = @footballer.get_teams_seasons

    
  end
end