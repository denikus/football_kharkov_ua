class StatisticsController < ApplicationController

  def show

    # получить турнир
    return false if request.subdomain.blank?

    tournament = Tournament.from_param(request.subdomain)

    # получить все сезоны и пройтись по матча сезона
    @seasons = tournament.step_seasons
  end
end