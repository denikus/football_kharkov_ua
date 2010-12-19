class Schedule < ActiveRecord::Base
  #belongs_to :tour
  belongs_to :venue
  belongs_to :hosts, :class_name => 'Team', :foreign_key => 'host_team_id'
  belongs_to :guests, :class_name => 'Team', :foreign_key => 'guest_team_id'
  #belongs_to :league
  belongs_to :step_tour, :foreign_key => 'tour_id'
  has_one :quick_match_result
  has_one :match
#  accepts_nested_attributes_for :quick_match_result, :allow_destroy => false
  

  def before_save
    self.league_id = Tour.find(:first,
                               :joins => "INNER JOIN stages ON (stages.id=tours.stage_id) " +
                                         "INNER JOIN seasons ON (stages.season_id=seasons.id) " + 
                                         "INNER JOIN leagues ON (leagues.stage_id=stages.id) " +
                                         "INNER JOIN leagues_teams ON (leagues.id=leagues_teams.league_id) ",
                               :conditions => ["tours.id = ? AND leagues_teams.team_id =? ", self.tour_id, self.host_team_id]
                                       )
  end

  def after_create
    new_match = create_match({})
    new_match.save!
    new_match.competitors.create({:team_id => self.host_team_id, :side => "hosts"})
    new_match.competitors.create({:team_id => self.guest_team_id, :side => "guests"})
  end

  def name
    new_record? ? "Новый матч в расписании" : ("#{match_on}, #{match_at}: #{hosts.name} - #{guests.name} (#{venue.name})")
  end
end
