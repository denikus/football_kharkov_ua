module Admin::TeamsHelper
  def select_teams league
    remote_function :url => admin_league_teams_path(league)
  end

  def select_teams_4_season season
    remote_function :url => admin_season_teams_path(season)
  end
end

