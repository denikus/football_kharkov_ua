# -*- encoding : utf-8 -*-
class PlayerRatesController < ApplicationController
  def index
    @seasons =  Step.find_all_by_tournament_id(Tournament.find_by_url(request.subdomain), :conditions => ["type = 'StepSeason'"])

    @leagues = StepLeague.get_leagues_in_season(@seasons.last)

    @league_footballers = FootballPlayer.all(
        :select => "football_players.*, footballers.*, steps_teams.step_id as league_id, teams.*",
         :joins =>
            "INNER JOIN footballers " +
              "ON (football_players.footballer_id = footballers.id)" +
            "INNER JOIN competitors " +
              "ON (football_players.competitor_id = competitors.id) " +
            "INNER JOIN steps_teams " +
              "ON steps_teams.team_id = competitors.team_id " +
            "INNER JOIN teams ON steps_teams.team_id = teams.id",
        :conditions => ["steps_teams.step_id in (#{@leagues.collect{|x| x.id}.join(',')})"],
        :group => "football_players.footballer_id")

    @league_footballers.each do |footballer|
      footballer_rate = PlayerLeagueRate.new footballer

      footballer[:rate] = footballer_rate.rate
    end

    @league_footballers.sort {|a,b| b.rate.to_f <=> a.rate.to_f}
  end
end
