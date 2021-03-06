# -*- encoding : utf-8 -*-
class MatchesController < ApplicationController
  layout "app_without_sidebar"

  def index
    tournament = Tournament.find_by_url(request.subdomain)

    @season = StepSeason.find(:first,
                             :conditions => ["url = ? AND tournament_id = ?", params[:season_id], tournament.id]
                             )
  end

  def show
    #@match = Match.find(:first,
    #                    :include => {:schedule => :step_tour},
    #                    :conditions => {:id => params[:id]}
    #                   )
    @match = Match.where(:id => params[:id]).includes(:schedule => :step_tour).first
  end
end
