class BombardiersController < ApplicationController
  layout "app_without_sidebar"

  def index
    @bombardiers = Footballer.paginate(:all,
                    :select => "`footballers`.*, `football_players`.id AS football_player_id, SUM(statistic.statable_total) AS statable_sum",
                    :joins => "INNER JOIN `football_players` " +
                                "ON (footballers.id = football_players.footballer_id) " +
                              "INNER JOIN (SELECT stats.statable_id, COUNT(stats.id) AS statable_total " + 
		                                       "FROM`stats` " +
		                                       "WHERE " +
		                                       "stats.statable_type='FootballPlayer' AND stats.name='goal' " +
                                        	 "GROUP BY stats.statable_id) AS statistic " +
                                "ON (statistic.statable_id=football_players.id)",
                    :conditions => "footballers.id > 0",
                    :group => "footballers.id ",
                    :order => "statable_sum DESC, footballers.last_name ASC",
                    :having => "statable_sum>2",
                    :per_page => 50,
                    :page => 1 
                  )
    bombardiers_grouped = {}
    @bombardiers.each do |item|
        if bombardiers_grouped[item[:statable_sum]].nil?
          bombardiers_grouped[item[:statable_sum]] = []
        end
        bombardiers_grouped[item[:statable_sum]] << item
    end
    @bombardier_list = bombardiers_grouped.sort {|a, b| b[0].to_i <=> a[0].to_i}
#    @bombardiers.sort {|a, b| a[:statable_sum] <=>}
=begin

    bombardiers_grouped = {}
    @bombardiers.each do |item|
      if item[:statable_sum].to_i > 1
        if bombardiers_grouped[item[:statable_sum]].nil?
          bombardiers_grouped[item[:statable_sum].to_i] = []
        end
        bombardiers_grouped[item[:statable_sum].to_i] << item
      end

    end
    @bombardier_list = bombardiers_grouped.sort

=end
#    ap bombardiers_grouped = @bombardiers.collect{|x| [x[:statable_sum], x]}
#    debugger
#    @bombardier_list.reverse!
#    @bombardier_list.delete_if{|x| x[0].to_i<3}
#    @bombardier_list.reverse!
  end
end

