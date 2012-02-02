# -*- encoding : utf-8 -*-
module Admin::MatchesHelper
  def show_matches tour
    remote_function :url => admin_tour_matches_path(tour)
  end
  
  def match_edit_select_team(side)
    remote_function :url => admin_match_stats_path('new'), :with => "'side=#{side}&team_id='+$(this).val()+'&season_id=#{@tour.league.stage.season_id}'"
  end
end
