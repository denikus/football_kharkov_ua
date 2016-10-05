class Admin::ClaimsController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin/temp"

  def index
    # get list of teams of last season
    tournament = Tournament.find_by_name('IT-Лига')
    last_season = StepSeason.where(:tournament_id => tournament.id).order("created_at ASC").last

    ap response = HTTParty.get(URI.escape("https://onetwoteam.com/api/v1/teams/tournament/itleague.json"))

    @teams = response["data"]

    # response.data.each do |team|
    #   @teams << {team}
    # end

    # last_season.stages.first.leagues.order("identifier ASC").each do |league|
    #   # @teams_by_groups << {:league_name  => league.name, :teams => league.teams}
    #   league.teams.each do |team|
    #     @teams << team
    #   end
    # end

  end

  def show
    # @team = Team.find(params[:id])

    ap response = HTTParty.get(URI.escape("https://onetwoteam.com/api/v1/claims/#{params[:id]}/tournament/itleague.json"))

    if response["data"].blank?
      redirect_to action: :index
      return
    end

    @team = Team.find_by_ott_uid(params[:id])

    tournament = Tournament.find_by_name('IT-Лига')
    last_season = StepSeason.where(:tournament_id => tournament.id).order("created_at ASC").last
    footballers = Footballer.by_team_step({:team_id => @team.id, :step_id => last_season.id} )

    @claims = []
    response["data"].each do |player|
      # search footballer by surname
      footballers = []
      footballers = Footballer.where("last_name LIKE ?", "%#{player["last_name"].squish}%") unless player["last_name"].nil?
      same_footballer = Footballer.where(ott_uid: player["player_id"]).first

      added = false

      unless same_footballer.nil?
        added = FootballersTeam.where(step_id: last_season.id, footballer_id: same_footballer.id, team_id: @team.id).count > 0
      end

      @claims << {ott_player: player, same_footballer: same_footballer, similar_footballers: footballers, added: added} #unless footballers.map{|footballer| footballer.ott_uid}.include?(player["uid"])
      # puts player["last_name"]
    end

  end

  def add_to_season
    @footballer = Footballer.find(params[:footballer_id])
    @team = Team.find_by_ott_uid(params[:claim_id])

    tournament = Tournament.find_by_name('IT-Лига')
    last_season = StepSeason.where(:tournament_id => tournament.id).order("created_at ASC").last

    # add footballer to team_seasons

    add_2_season(@team.id, last_season.id, @footballer.id)

    redirect_to admin_claim_path(params[:claim_id])
  end

  def merge_player
    # ap params
    @footballer = Footballer.find(params[:footballer_id])
    @team = Team.find_by_ott_uid(params[:claim_id])

    ott_response = HTTParty.get(URI.escape("https://onetwoteam.com/api/v1/claims/#{params[:claim_id]}/player.json?player_id=#{params[:ott_player_id]}"))

    # update uid if footballer's uid empty
    @footballer.update_attribute(:ott_uid, params[:ott_player_id]) if @footballer.ott_uid.blank?

    # update photo
    # @footballer.photo = "https://onetwoteam.com#{ott_response["photo"]}"

    # @footballer.save

    tournament = Tournament.find_by_name('IT-Лига')
    last_season = StepSeason.where(:tournament_id => tournament.id).order("created_at ASC").last

    # add footballer to team_seasons
    #FootballersTeam.create(team_id: @team.id, step_id: last_season.id, footballer_id: @footballer.id)

    add_2_season(@team.id, last_season.id, @footballer.id)

    redirect_to admin_claim_path(params[:claim_id])
  end

  def add_merge_player
    # create footballer
    @team = Team.find_by_ott_uid(params[:claim_id])
    ap response = HTTParty.get(URI.escape("https://onetwoteam.com/api/v1/claims/#{params[:claim_id]}/player.json?player_id=#{params[:ott_player_id]}"))

    args = {first_name: response["first_name"], last_name: response["last_name"], ott_uid: params[:ott_player_id]}
    args.merge!({patronymic: response["patronymic"]}) unless response["patronymic"].blank?
    args.merge!({birth_date: response["birthdate"]}) unless response["birthdate"].blank?

    @footballer = Footballer.create(args)

    unless @footballer.nil?

      tournament = Tournament.find_by_name('IT-Лига')
      last_season = StepSeason.where(:tournament_id => tournament.id).order("created_at ASC").last

      # FootballersTeam.create(team_id: @team.id, step_id: last_season.id, footballer_id: @footballer.id)
      add_2_season(@team.id, last_season.id, @footballer.id)
    end

    redirect_to admin_claim_path(params[:claim_id])

  end

  private

  def add_2_season(team_id, season_id, footballer_id)
    FootballersTeam.create(team_id: @team.id, step_id: season_id, footballer_id: @footballer.id)
  end
end
