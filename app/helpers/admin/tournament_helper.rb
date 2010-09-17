module Admin::TournamentHelper
  def tournament_title
    current_subdomain.nil? ? "" : Tournament.find_by_url(current_subdomain).name  
  end
end
