class Schedule < ActiveRecord::Base
  belongs_to :season
  belongs_to :venue
  belongs_to :hosts, :class_name => 'Team', :foreign_key => 'host_team_id'
  belongs_to :guests, :class_name => 'Team', :foreign_key => 'guest_team_id'
  belongs_to :league

  def before_save
    self.league_id = Season.find(:first,
                               :joins => "INNER JOIN stages ON (stages.season_id=seasons.id) " +
                                         "INNER JOIN leagues ON (leagues.stage_id=stages.id) " + 
                                         "INNER JOIN leagues_teams ON (leagues.id=leagues_teams.league_id) ",
                               :conditions => ["seasons.id = ? AND leagues_teams.team_id =? ", self.season_id, self.host_team_id]
                                       )
  end

  def name
    new_record? ? "Новый матч в расписании" : ("#{match_on}, #{match_at}: #{hosts.name} - #{guests.name} (#{venue.name})")
  end
end
