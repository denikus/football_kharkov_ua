class Schedule < ActiveRecord::Base
  #belongs_to :tour
  belongs_to :venue
  belongs_to :hosts, :class_name => 'Team', :foreign_key => 'host_team_id'
  belongs_to :guests, :class_name => 'Team', :foreign_key => 'guest_team_id'
  #belongs_to :league
  belongs_to :step_tour, :foreign_key => 'tour_id'
  belongs_to :step_league, :foreign_key => 'league_id'
  #has_one :quick_match_result
  has_one :match
#  accepts_nested_attributes_for :quick_match_result, :allow_destroy => false
  

  #def before_save
  #  self.league_id = Tour.find(:first,
  #                             :joins => "INNER JOIN stages ON (stages.id=tours.stage_id) " +
  #                                       "INNER JOIN seasons ON (stages.season_id=seasons.id) " + 
  #                                       "INNER JOIN leagues ON (leagues.stage_id=stages.id) " +
  #                                       "INNER JOIN leagues_teams ON (leagues.id=leagues_teams.league_id) ",
  #                             :conditions => ["tours.id = ? AND leagues_teams.team_id =? ", self.tour_id, self.host_team_id]
  #                                     )
  #end

  def after_create
    new_match = create_match({})
    new_match.save!
    new_match.competitors.create({:team_id => self.host_team_id, :side => "hosts"})
    new_match.competitors.create({:team_id => self.guest_team_id, :side => "guests"})
  end

  def name
    new_record? ? "Новый матч в расписании" : ("#{match_on}, #{match_at}: #{hosts.name} - #{guests.name} (#{venue.name})")
  end

  class << self
    def get_min_date(tournament)
      min = find(:first,
                 :select => "MIN(match_on) AS match_on",
                 :joins => "INNER JOIN `steps`" +
                            "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",
                 :conditions => !tournament.nil? ? ["tournament_id = ?", tournament.id] : "1"
#                 :conditions => ["steps.tournament_id = ? ", tournament.id]
                 )
    end

    def get_max_date(tournament)
      max = find(:first,
                 :select => "MAX(match_on) AS match_on",
                 :joins => "INNER JOIN `steps`" +
                            "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",
                 :conditions => !tournament.nil? ? ["tournament_id = ?", tournament.id] : "1"
#                 :conditions => ["steps.tournament_id = ? ", tournament.id]
                 )
    end

    def get_tomorrow_record(tournament)
      unless tournament.nil?
        conditions = ["match_on >= ? AND steps.tournament_id = ? ", Time.now.to_date, tournament.id]
      else
        conditions = ["match_on >= ? ", Time.now.to_date]
      end  

      schedule_date = find(:first,
                           :select => "match_on",
                           :joins => "INNER JOIN `steps` " +
                                       "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",
                           :conditions => conditions,
                           :order => "match_on",
                           :limit => 1
                           )
    end

    def get_records_by_day(day, tournament)
      unless tournament.nil?
        conditions = ["match_on = ?  AND steps.tournament_id = ?", day,  tournament.id]
      else
        conditions = ["match_on = ? ", day]
      end
      find(:all,
            :select => "schedules.*, leagues.name AS league_name, leagues.short_name AS league_short_name",
            :joins => "INNER JOIN `steps`" +
                "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour') " +
                "LEFT JOIN `steps` AS leagues " +
                  "ON (schedules.league_id = leagues.id AND leagues.type = 'StepLeague') ",
            :conditions => conditions,
            :include => [:hosts, :guests, :venue],
            :order => "match_at ASC"
           )
    end
  end  
end
