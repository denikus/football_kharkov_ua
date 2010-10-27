module Admin::TeamsHelper
  def select_teams league
    remote_function :url => admin_league_teams_path(league)
  end

  def select_teams_4_season season
    remote_function :url => admin_season_teams_path(season)
  end
  
  def team_footballers_season_select team, season
    remote_function :url => admin_team_footballers_path(team), :with => "'season_id=#{season.id}&token=#{Time.now.to_i}'"
  end
end

