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

  after_create :create_resources

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

  def create_resources
    new_match = create_match
    new_match.save!
    new_match.competitors.create({:team_id => self.host_team_id, :side => "hosts"})
    new_match.competitors.create({:team_id => self.guest_team_id, :side => "guests"})
  end

  def name
    new_record? ? "Новый матч в расписании" : ("#{match_on}, #{match_at}: #{hosts.name} - #{guests.name} (#{venue.name})")
  end
  
  def short_info
    {:id => id, :hosts => hosts.name, :guests => guests.name, :time => match_at}
  end

  class << self

    def future_footballer_matches(footballer_id)
      #get seasons where footballer play in team
      tours = FootballersTeam.
              select("footballers_teams.*, `tours`.id AS tour_id").
              joins("INNER JOIN `steps_phases` AS `stages_phase` ON (`stages_phase`.`step_id` = `footballers_teams`.`step_id`) " +
                    "INNER JOIN `steps_phases` AS `tours_phase` ON (`tours_phase`.`step_id` = `stages_phase`.`phase_id`) " +
                    "INNER JOIN `steps` AS `tours` ON (`tours`.`id` = `tours_phase`.`phase_id` AND `tours`.`type`='StepTour') " +
                    "INNER JOIN `schedules` ON (`schedules`.`tour_id` = `tours`.`id` ) ").
              where( "footballer_id =? AND `schedules`.match_on > ?", footballer_id, Time.now.to_date).collect{|x| x.tour_id}.uniq
      joins("LEFT JOIN `footballers_teams` AS `with_guest_team` ON (`with_guest_team`.`team_id` = `schedules`.`guest_team_id` AND `with_guest_team`.`footballer_id` = #{footballer_id.to_i}) " +
            "LEFT JOIN `footballers_teams` AS `with_host_team` ON (`with_host_team`.`team_id` = `schedules`.`host_team_id` AND `with_host_team`.`footballer_id` = #{footballer_id.to_i})").
      where("`schedules`.host_scores IS NULL AND `schedules`.guest_scores IS NULL AND `schedules`.match_on > ? AND `schedules`.`tour_id` IN (?) AND (`with_guest_team`.`team_id` IS NOT NULL OR `with_host_team`.`team_id` IS NOT NULL )", Time.now.to_date, tours.join(',')).
      group("`schedules`.id")
    end

    def get_min_date(tournament, with_results = false)

      condition_str = "1"
      condition_vals = []

      unless tournament.nil?
        condition_str += " AND tournament_id = ? "
        condition_vals << tournament.id
      end

      if with_results
        condition_str += " AND (host_scores IS NOT NULL AND guest_scores IS NOT NULL) "
      end

      find(:first,
                 :select => "MIN(match_on) AS match_on",
                 :joins => "INNER JOIN `steps`" +
                            "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",
                 :conditions => [condition_str] + condition_vals
#                 :conditions => !tournament.nil? ? ["tournament_id = ?", tournament.id] : "1"
#                 :conditions => ["steps.tournament_id = ? ", tournament.id]
                 )
      
    end

    def get_max_date(tournament, with_results = false)
      condition_str = "1"
      condition_vals = []

      unless tournament.nil?
        condition_str += " AND tournament_id = ? "
        condition_vals << tournament.id
      end

      if with_results
        condition_str += " AND (host_scores IS NOT NULL AND guest_scores IS NOT NULL) "
      end
      
      find(:first,
                 :select => "MAX(match_on) AS match_on",
                 :joins => "INNER JOIN `steps`" +
                            "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",
                 :conditions => [condition_str] + condition_vals
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
