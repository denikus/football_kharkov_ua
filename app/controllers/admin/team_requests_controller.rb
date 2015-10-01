require 'json'
require 'open-uri'

class Admin::TeamRequestsController < ApplicationController
  before_filter :authenticate_admin!

  layout "admin/temp"

  def index
    cookies[:season_id] ||= StepSeason.where(tournament_id: 1).order("created_at DESC").first.id

    @seasons = StepSeason.where(tournament_id: 1).order("created_at DESC").all

    # get teams by season
    team_ids = Step.find(cookies[:season_id]).team_ids
    @teams = Team.where(id: team_ids)

  end

  def show
    # get team
    @team = Team.find(params[:id])

    # get team's players from onetwoteam.com
    @api_players = JSON.parse(open(URI.escape("https://onetwoteam.com/api/v1/teams/#{@team.name}.json")).read)
    @fhu_players = []
    @api_players.each_with_index do |api_player, index|

      variants = Footballer.where("first_name LIKE '%#{api_player["first_name"]}%' AND last_name LIKE '%#{api_player["last_name"]}%'")
      if !variants.empty?
        @fhu_players[index] = variants
      else
        puts "#{api_player["first_name"]} #{api_player["last_name"]}"
      end
    end

    @footballer_ids = Team.find(@team.id).footballer_ids[cookies[:season_id]]

    @footballers = Footballer.by_team_step({:team_id => @team.id, :step_id => cookies[:season_id]} )

  end

  def add_player
    team = Team.find(params[:id])
    # Team.find(params[:id]).footballer_ids[params[:step_id]] = params[:footballer_ids].split(',').map(&:to_i)
    FootballersTeam.create({:step_id => params[:step_id], :team_id => team.id, :footballer_id => params[:footballer_id]})

    respond_to do |format|
      format.json {render json: {success: true}}
    end
  end

  def create_player
    team = Team.find(params[:id])

    @footballer = Footballer.new(first_name: params[:first_name], last_name: params[:last_name], patronymic: params[:patronymic], birth_date: params[:birth_date])

    if @footballer.save
      FootballersTeam.create({:step_id => params[:step_id], :team_id => team.id, :footballer_id => @footballer.id})
    end

    respond_to do |format|
      format.json {render json: {success: true}}
    end

  end
end
