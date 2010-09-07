module Admin::TeamsHelper
  def select_teams league
    remote_function :url => admin_league_teams_path(league)
  end
end
