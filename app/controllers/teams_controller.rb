class TeamsController < ApplicationController
  layout "app_without_sidebar"
  def index
    unless current_subdomain.nil?
      @teams = Tournament.find_by_url(current_subdomain).seasons.last.teams.find(:all, :order => "name ASC")
    end
  end
end
