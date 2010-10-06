class BombardiersController < ApplicationController
  layout "app_without_sidebar"

  def index
    @bombardiers = Footballer.paginate(:all,
                    :select => "`footballers`.*, `football_players`.id AS football_player_id, statistic.statable_total",
                    :joins => "INNER JOIN `football_players` " +
                                "ON (footballers.id = football_players.footballer_id) " +
                              "INNER JOIN (SELECT stats.statable_id, COUNT(stats.value) AS statable_total " + 
		                                       "FROM`stats` " +
		                                       "WHERE " +
		                                       "stats.statable_type='FootballPlayer' AND stats.name='goal' " +
                                        	 "GROUP BY stats.statable_id) AS statistic " +
                                "ON (statistic.statable_id=football_players.id)",
                    :conditions => "footballers.id > 0",
                    :order => "statistic.statable_total DESC, footballers.last_name ASC",
                    :per_page => 10,
                    :page => 1 
                  )
    
  end
end
