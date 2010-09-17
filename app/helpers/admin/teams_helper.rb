module Admin::TeamsHelper
  def select_teams league
    remote_function :url => admin_league_teams_path(league)
  end
  
  def team_footballers_season_select team, season
    remote_function :url => admin_team_footballers_path(team), :with => "'season_id=#{season.id}'"
  end
end
