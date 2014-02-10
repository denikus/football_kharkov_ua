class Api::V1::TablesController < Api::V1::BaseController
  before_filter :find_tournament

  def index
    #get last season if not provided
    params[:season_url] ||= StepSeason.by_tournament(@tournament.id).last[:url]
    @season = StepSeason.by_tournament(@tournament.id).where(url: params[:season_url]).first

    # return error if no season with such url
    error!("Incorrect params", 403) and return if @season.nil?
    #ap StepSeason.where(tournament_id: @tournament.id, id: @season.id)

    @stages = StepSeason.where(tournament_id: @tournament.id, id: @season.id).first.stages.order('created_at ASC').all

    response = []

    @stages.each do |stage|
      leagues = []
      stage.leagues.each do |league|
        records = league.table_set[0].get unless league.table_set[0].nil?
        records ||= []
        rows = []
        records.each_with_index do |record, index|
          rows << {position: index + 1,
                   position_change: record.position_change,
                   team: record.team.name,
                   games: record.games_count,
                   wins: record.games[0],
                   draws: record.games[1],
                   loses: record.games[2],
                   goals_for: record.goals[0],
                   goals_against: record.goals[1],
                   goals_diff: "#{record.goals[0] - record.goals[1] > 0 ? "+" : ""}#{record.goals[0] - record.goals[1]}",
                   scores: record.score
                 }
        end
        leagues << {league_name: league.name, rows: rows}



        #ap league
      end
      response << {stage: stage.name, leagues: leagues}
    end

    respond_to do |format|
      format.json{ render json: response }
    end

  end
end
