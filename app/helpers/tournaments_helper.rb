module TournamentsHelper
  def tournament_title
    current_subdomain.nil? ? "" : link_to_unless_current(Tournament.find_by_url(current_subdomain).name, tournament_path, :class=>"tournament-main-title")  do |name|
      "<span>#{name}</span>".html_safe
    end
  end
end
