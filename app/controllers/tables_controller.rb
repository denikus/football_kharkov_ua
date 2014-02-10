# -*- encoding : utf-8 -*-
class TablesController < ApplicationController
  layout "app_without_sidebar"
  
  def index
    tournament = Tournament.find_by_url(request.subdomain)

    @stages = StepSeason.by_tournament(tournament.id).last.stages.order('created_at ASC').all

  end
end
