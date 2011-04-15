class FootballersController < ApplicationController
  layout "app_without_sidebar"
  
  def show
    @footballer = Footballer.find_by_url(params[:id])


    tournaments = @footballer.footballers_teams.joins(:step).group("steps.tournament_id").collect{|item| item.step.tournament}

    @tournaments_teams = []

    tournaments.each do |tournament|
      last_season = StepSeason.by_footballer(@footballer.id).by_tournament(tournament.id).last
      last_season_teams = @footballer.footballers_teams.includes(:team).where('step_id = ?', last_season)

      @team_stats = []
      last_season_teams.each do |footballer_team|
        team = footballer_team.team
        matches = []
        #count total number of team matches in current season
        footballer_team.step.stages.collect{|stage| stage.tours.map{|tour| tour.schedules.map{|schedule| matches << schedule.match if (!schedule.host_scores.nil? && (schedule.host_team_id == team.id || schedule.guest_team_id == team.id)) }}}

        #count number of matches played by the footballer
        played_matches = Match.played_by_footballer(matches.collect{|m| m.id}, team.id, @footballer.id)

        #get competitors by season
        competitors = Competitor.by_team_matches(team.id, played_matches)

        #get football_players by season
        football_players = FootballPlayer.by_competitor_footballer(competitors.collect{|c| c.id}, @footballer.id)

        #get statistic for football_players
        stats = Stat.by_football_players(football_players.collect{|x| x.id})
        statistic = {}
        FootballPlayer::STATS.each{|s| statistic.merge!({s.to_sym => nil})}
        stats.each{|item| statistic[item[:name].to_sym] = item["stat_count"]}
        
        @team_stats << {:team => team,
                   :league =>  team.get_league(@footballer.id, last_season.id),
                   :total_team_matches => matches.count,
                   :footballer_matches => played_matches.count,
                   :goal => statistic[:goal],
                   :auto_goal => statistic[:auto_goal],
                   :yellow_card => statistic[:yellow_card],
                   :red_card => statistic[:red_card]
                   }
      end
      @tournaments_teams << {
                             :tournament => tournament,
                             :season => last_season,
                             :teams_stats => @team_stats
                            }
    end
    @schedules = Schedule.future_footballer_matches(@footballer.id)


#    ap @footballer.footballers_teams.joins(:step).group("steps.tournament_id").to_sql
    
#    @footballer.footballers_teams
#    @tournaments_take_part = @footballer.get_teams_seasons

    
  end
end