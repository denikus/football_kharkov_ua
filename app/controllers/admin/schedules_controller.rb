class Admin::SchedulesController < ApplicationController
  layout 'admin/main'

  admin_section :tournaments
    
  def index
#    @seasons = Season.all
    @tournament = Tournament.find_by_url(params[:tournament_id])
    @seasons    = @tournament.seasons
    @teams    = @seasons.last.teams
  end
end
