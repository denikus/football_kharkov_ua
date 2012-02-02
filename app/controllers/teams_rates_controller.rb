# -*- encoding : utf-8 -*-
class TeamsRatesController < ApplicationController
  def index
    tournament = Tournament.find_by_url(request.subdomain)

    @seasons =  Step.find_all_by_tournament_id(
        tournament,
        :conditions => ["type = 'StepSeason'"])

    leagues = StepLeague.find_all_by_tournament_id(tournament.id)

    @teams = Team.paginate(
        :all,
        :select => "teams.*",
        :joins =>  "INNER JOIN `competitors` " +
                  "ON (teams.id = competitors.team_id) " +
             "INNER JOIN `matches` " +
                                "ON (competitors.match_id = matches.id) "+
                              "INNER JOIN `schedules` " +
                                "ON (matches.schedule_id = schedules.id) "+
                              "INNER JOIN `steps` AS leagues " +
                                "ON (schedules.league_id = leagues.id) ",
        :conditions => "schedules.league_id IN (#{leagues.collect!{|x| x.id}.join(',')})",
        :group => 'teams.id',
        :per_page => 50,
        :page => 1
                  
    )

    @teams.each do |team|
      team_stats = {}

      @seasons.each do |season|
        team_stats[season.name] = SeasonStats.new(team, season)
      end

      team[:rate] = 0
      actual_stats = []
      team_stats.each_value{|season_stat| if !season_stat.season_rate.nil? then actual_stats << season_stat end}
      actual_stats.each{|season_stat| team[:rate] += season_stat.season_rate}
      team[:rate] /= actual_stats.length.to_f
      team[:stats] = team_stats
    end

    @teams = @teams.sort {|a,b| b.rate.to_f <=> a.rate.to_f}
  end
end
