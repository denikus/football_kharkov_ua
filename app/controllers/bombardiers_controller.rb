class BombardiersController < ApplicationController
  layout "app_without_sidebar"

  def index
    seasons =  Step.find_all_by_tournament_id(Tournament.find_by_url(current_subdomain), :conditions => ["type = 'StepSeason'"])

    @leagues = StepLeague.find(:all,
                               :select => "steps.* ",
                               :joins => "INNER JOIN `steps_phases` AS stages_2_leagues " +
                                            "ON (steps.id = stages_2_leagues.phase_id) " +
                                          "INNER JOIN `steps_phases` AS seasons_2_stages " +
                                            "ON (stages_2_leagues.step_id = seasons_2_stages.phase_id)" +
                                          "INNER JOIN `steps` AS seasons " +
                                            "ON (seasons_2_stages.step_id = seasons.id AND seasons.type = 'StepSeason')", 
                               :conditions => ["seasons.id = ? AND steps.type = 'StepLeague'", seasons.last]
                              )

    @bombardiers = Footballer.paginate(:all,
                    :select => "`footballers`.*, `football_players`.id AS football_player_id, `competitors`.team_id AS team_id, SUM(statistic.statable_total) AS statable_sum",
                    :joins => "INNER JOIN `football_players` " +
                                "ON (footballers.id = football_players.footballer_id) " +
                              "INNER JOIN `competitors` " +
                                "ON (football_players.competitor_id = competitors.id) "+
                              "INNER JOIN `matches` " +
                                "ON (competitors.match_id = matches.id) "+
                              "INNER JOIN `schedules` " +
                                "ON (matches.schedule_id = schedules.id) "+
                              "INNER JOIN `steps` AS leagues " +
                                "ON (schedules.league_id = leagues.id) "+
                              "INNER JOIN (SELECT stats.statable_id, COUNT(stats.id) AS statable_total " +
		                                       "FROM`stats` " +
		                                       "WHERE " +
		                                       "stats.statable_type='FootballPlayer' AND stats.name IN ('goal', 'goal_6', 'goal_10') " +
                                        	 "GROUP BY stats.statable_id) AS statistic " +
                                "ON (statistic.statable_id=football_players.id) ",
                    :conditions => ["footballers.id >0 AND leagues.id IN (#{@leagues.collect!{|x| x.id}.join(',')})"],
                    :group => "competitors.team_id, footballers.id ",
                    :order => "statable_sum DESC, footballers.last_name ASC",
                    :per_page => 50,
                    :page => 1
                  )
    bombardiers_grouped = {}
    @bombardiers.each do |item|
      if item[:statable_sum].to_i > 0
        if bombardiers_grouped[item[:statable_sum]].nil?
          bombardiers_grouped[item[:statable_sum]] = []
        end
        bombardiers_grouped[item[:statable_sum]] << item
      end
    end
    @bombardier_list = bombardiers_grouped.sort {|a, b| b[0].to_i <=> a[0].to_i}
  end
end

