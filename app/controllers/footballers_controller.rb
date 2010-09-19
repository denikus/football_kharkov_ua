class FootballersController < ApplicationController
  layout "app_without_sidebar"
  
  def show
    @footballer = Footballer.find_by_url(params[:id])
    @tournaments_take_part = @footballer.get_teams_seasons
  end
end