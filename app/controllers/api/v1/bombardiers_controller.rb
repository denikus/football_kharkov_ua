class Api::V1::BombardiersController < Api::V1::BaseController
  before_filter :find_tournament

  def index
    #get last season if not provided
    params[:season_url] ||= StepSeason.by_tournament(@tournament.id).last[:url]
    @season = StepSeason.by_tournament(@tournament.id).where(url: params[:season_url]).first

    # return error if no season with such url
    error!("Incorrect params", 403) and return if @season.nil?


    # season_tags = Step.find_all_by_tournament_id(Tournament.find_by_url(request.subdomain), :conditions => ["type = 'StepSeason'"]).last.league_tags
    season_tags = @season.league_tags

    @tags = []

    season_tags.each do |tag|
      @bombardiers = Footballer.select("footballers.*, competitors.team_id AS team_id, SUM(statistic.statable_total) AS statable_sum").
          joins("INNER JOIN football_players " +
                    "ON (footballers.id = football_players.footballer_id) " +
                    "INNER JOIN competitors " +
                    "ON (football_players.competitor_id = competitors.id) "+
                    "INNER JOIN matches " +
                    "ON (competitors.match_id = matches.id) "+
                    "INNER JOIN schedules " +
                    "ON (matches.schedule_id = schedules.id) "+
                    "INNER JOIN steps AS leagues " +
                    "ON (schedules.league_id = leagues.id) "+
                    "INNER JOIN (SELECT stats.statable_id, COUNT(stats.id) AS statable_total " +
                    "FROM stats " +
                    "WHERE " +
                    "stats.statable_type='FootballPlayer' AND stats.name IN ('goal', 'goal_6', 'goal_10') " +
                    "GROUP BY stats.statable_id) AS statistic " +
                    "ON (statistic.statable_id=football_players.id) ").
          where(["footballers.id >0 AND leagues.id IN (#{ tag.step_leagues.size > 0 ? tag.step_leagues.collect!{|x| x.id}.join(',') : "0" })"]).
          group("competitors.team_id, footballers.id").
          #paginate(:per_page => 50,:page => 1).
          order("statable_sum DESC, footballers.last_name ASC")
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
      @tags << {name: tag.name, bombardiers: @bombardier_list}
    end

    respond_to do |format|
      format.json{ render json: @tags }
    end
  end
end