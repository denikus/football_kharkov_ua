class TeamApplicationController < ApplicationController
  layout "app_without_sidebar"
  def index
    unless request.subdomain.nil?
      tournament = Tournament.find_by_url(request.subdomain)
      last_season = StepSeason.where(:tournament_id => tournament.id).order("identifier ASC").last


      applications = Application.where({owner_id: current_user.id, season_id: last_season})
      #current_user.id =
      #ap applications
    end
  end
end
