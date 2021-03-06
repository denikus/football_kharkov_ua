# -*- encoding : utf-8 -*-
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
      select("schedules.*, footballers_teams.footballer_id ").
      joins(
            "INNER JOIN steps_phases AS tours_phase ON (tours_phase.phase_id = schedules.tour_id) " +
            "INNER JOIN steps_phases AS seasons_phase ON (seasons_phase.phase_id = tours_phase.step_id) " +
            "INNER JOIN footballers_teams ON (footballers_teams.step_id = seasons_phase.step_id) " +
            "LEFT JOIN footballers_teams AS with_guest_team ON (with_guest_team.team_id = schedules.guest_team_id AND with_guest_team.footballer_id = #{footballer_id.to_i}) " +
            "LEFT JOIN footballers_teams AS with_host_team ON (with_host_team.team_id = schedules.host_team_id AND with_host_team.footballer_id = #{footballer_id.to_i})"
           ).
      where("schedules.host_scores IS NULL AND schedules.guest_scores IS NULL AND footballers_teams.footballer_id = ? AND schedules.match_on > ? AND ( with_guest_team.team_id = footballers_teams.team_id OR with_host_team.team_id  = footballers_teams.team_id )", footballer_id, Time.now.to_date).
      group("schedules.id, footballers_teams.footballer_id")
    end

    def future_team_matches(team_id)
      schedules = Competitor.
          select("matches.schedule_id").
          joins("INNER JOIN matches ON competitors.match_id = matches.id").
          where('competitors.team_id = ?', team_id).collect{|x| x.schedule_id.to_s}.uniq
      if !schedules.empty?
        where("schedules.host_scores IS NULL AND schedules.guest_scores IS NULL AND schedules.match_on > ? AND schedules.id in (#{schedules.join(',')})", Time.now.to_date).
        group("schedules.id")
      else
        return []
      end
    end

    def get_min_date(tournament, with_results = false)

      condition_str = "true"
      condition_vals = []

      unless tournament.nil?
        condition_str += " AND tournament_id = ? "
        condition_vals << tournament.id
      end

      if with_results
        condition_str += " AND (host_scores IS NOT NULL AND guest_scores IS NOT NULL) "
      end

      select("MIN(match_on) AS match_on").joins("INNER JOIN steps ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')").where([condition_str] + condition_vals).first
      #find(:first,
      #           :select => ,
      #           :joins =>  +
      #                      "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",
      #           :conditions => [condition_str] + condition_vals
      #           )
      
    end

    def get_max_date(tournament, with_results = false)
      condition_str = "true"
      condition_vals = []

      unless tournament.nil?
        condition_str += " AND tournament_id = ? "
        condition_vals << tournament.id
      end

      if with_results
        condition_str += " AND (host_scores IS NOT NULL AND guest_scores IS NOT NULL) "
      end
      select("MAX(match_on) AS match_on").joins("INNER JOIN steps ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')").where([condition_str] + condition_vals).first
#      find(:first,
#                 :select => "MAX(match_on) AS match_on",
#                 :joins => "INNER JOIN steps" +
#                            "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",
#                 :conditions => [condition_str] + condition_vals
##                 :conditions => ["steps.tournament_id = ? ", tournament.id]
#                 )
    end

    def get_tomorrow_record(tournament)
      unless tournament.nil?
        conditions = ["match_on >= ? AND steps.tournament_id = ? ", Time.now.to_date, tournament.id]
      else
        conditions = ["match_on >= ? ", Time.now.to_date]
      end  

      schedule_date = find(:first,
                           :select => "match_on",
                           :joins => "INNER JOIN steps " +
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
      #includes([:hosts, :guests, :venue])
      select("schedules.*, leagues.name AS league_name, leagues.short_name AS league_short_name, seasons.name AS season_name").joins("INNER JOIN steps ON (schedules.tour_id = steps.id AND steps.type = 'StepTour') " +
                                                                                                            "LEFT JOIN steps_phases as tours_phase ON (tours_phase.phase_id = schedules.tour_id) " +
                                                                                                            "LEFT JOIN steps_phases as seasons_phase ON (seasons_phase.phase_id = tours_phase.step_id) " +
                                                                                                            "LEFT JOIN steps AS seasons ON (seasons_phase.step_id = seasons.id AND seasons.type = 'StepSeason') " +
                                                                                                            "LEFT JOIN steps AS leagues ON (schedules.league_id = leagues.id AND leagues.type = 'StepLeague') ").where(conditions).includes(:hosts, :guests, :venue).order("match_at ASC")
      #find(:all,
      #      :select => "schedules.*, leagues.name AS league_name, leagues.short_name AS league_short_name",
      #      :joins => "INNER JOIN steps" +
      #          "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour') " +
      #          "LEFT JOIN steps AS leagues " +
      #            "ON (schedules.league_id = leagues.id AND leagues.type = 'StepLeague') ",
      #      :conditions => conditions,
      #      :include => [:hosts, :guests, :venue],
      #      :order => "match_at ASC"
      #     )
    end
  end  
end
