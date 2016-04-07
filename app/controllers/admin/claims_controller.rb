class Admin::ClaimsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin/temp"

  def index
    # get list of teams of last season
    tournament = Tournament.find_by_name('IT-Лига')
    last_season = StepSeason.where(:tournament_id => tournament.id).order("created_at ASC").last

    @teams = []
    last_season.stages.first.leagues.order("identifier ASC").each do |league|
      # @teams_by_groups << {:league_name  => league.name, :teams => league.teams}
      league.teams.each do |team|
        @teams << team
      end
    end

  end

  def show
    @team = Team.find(params[:id])

    response = HTTParty.get(URI.escape("https://onetwoteam.com/api/v1/claims/#{@team.name}.json"))



    tournament = Tournament.find_by_name('IT-Лига')
    last_season = StepSeason.where(:tournament_id => tournament.id).order("created_at ASC").last
    footballers = Footballer.by_team_step({:team_id => @team.id, :step_id => last_season.id} )

    @claims = []
    response.each do |player|
      # search footballer by surname
      footballers = []
      footballers = Footballer.where("last_name LIKE ?", "%#{player["last_name"].squish}%") unless player["last_name"].nil?


      @claims << {ott_player: player, footballers: footballers} unless footballers.map{|footballer| footballer.ott_player_id}.include?(player["player_id"])
      # puts player["last_name"]
    end

  end

  def merge_player
    # ap params
    @footballer = Footballer.find(params[:footballer_id])
    @team = Team.find(params[:claim_id])

    @footballer.update_attribute(:ott_player_id, params[:ott_player_id]) if @footballer.ott_player_id.blank?



    tournament = Tournament.find_by_name('IT-Лига')
    last_season = StepSeason.where(:tournament_id => tournament.id).order("created_at ASC").last

    # add footballer to team_seasons
    FootballersTeam.create(team_id: @team.id, step_id: last_season.id, footballer_id: @footballer.id)

    redirect_to admin_claim_path(params[:claim_id])

  end

  def add_merge_player
    # create footballer
    @team = Team.find(params[:claim_id])
    response = HTTParty.get(URI.escape("https://onetwoteam.com/api/v1/claims/#{@team.name}/player.json?player_id=#{params[:ott_player_id]}"))

    args = {first_name: response["first_name"], last_name: response["last_name"], ott_player_id: params[:ott_player_id]}
    args.merge!({patronymic: response["patronymic"]}) unless response["patronymic"].blank?
    args.merge!({birth_date: response["birth_date"]}) unless response["birth_date"].blank?

    @footballer = Footballer.create(args)

    unless @footballer.nil?

      tournament = Tournament.find_by_name('IT-Лига')
      last_season = StepSeason.where(:tournament_id => tournament.id).order("created_at ASC").last

      FootballersTeam.create(team_id: @team.id, step_id: last_season.id, footballer_id: @footballer.id)
    end

    redirect_to admin_claim_path(params[:claim_id])

  end
end
