# -*- encoding : utf-8 -*-

class Team < ActiveRecord::Base
  #has_many :footballers_teams, :include => :footballer
  #has_many :footballers, :through => :footballers_teams
  #has_and_belongs_to_many :footballers
  #has_and_belongs_to_many :leagues
  #has_and_belongs_to_many :seasons
  has_many :competitors, :dependent => :destroy
  
  has_many :footballers_teams
  has_and_belongs_to_many :steps

  before_save :prepare_url

  def footballer_ids
    @footballers_proxy ||= FootballersProxy.new self
  end

  def prepare_url
    self.url = self.name.gsub(/[^a-zA-Zа-яА-Я0-9\-]/, '-')
  end

  def get_league(footballer_id, season_id)
    Team.select("step_leagues.* ").
              joins(
                "INNER JOIN `footballers_teams` ON (`footballers_teams`.team_id = `teams`.id) " +
                "INNER JOIN `steps_phases` AS stages ON (`stages`.step_id = `footballers_teams`.step_id) " +
                "INNER JOIN `steps_phases` AS leagues ON (`leagues`.step_id = `stages`.phase_id) " +
                "INNER JOIN `steps_teams` ON (`steps_teams`.step_id = `leagues`.phase_id) " +
                "INNER JOIN `steps` AS step_leagues ON (`step_leagues`.id = `steps_teams`.step_id AND `step_leagues`.type = 'StepLeague') "
              ).
            where(
              [" `teams`.id = ? AND  `footballers_teams`.step_id = ? AND `footballers_teams`.footballer_id = ? AND `steps_teams`.team_id = ? ", self, season_id, footballer_id, self]
            ).group("step_leagues.id").first
  end

  def get_schedule_for_season(season_id)

    leagues = StepLeague.get_leagues_in_season(season_id)

    team_stats = (leagues.length > 0
        ) ? Schedule.find(
            :all,
            :conditions => [
                "(host_team_id = #{self.id} OR guest_team_id = #{self.id}) AND league_id IN (#{leagues.collect!{|x| x.id}.join(',')})"]
        ) : nil

    team_stats
  end

  class FootballersProxy < ActiveSupport::BasicObject
    def initialize team
      @team = team
    end
    
    def [] step_id
      ::Footballer.by_team_step(:team_id => @team.id, :step_id => step_id).map(&:id)
    end
    
    def []= step_id, ids
      ::FootballersTeam.delete_all(:step_id => step_id, :team_id => @team.id)
      ::FootballersTeam.create ids.collect{ |id| {:step_id => step_id, :team_id => @team.id, :footballer_id => id} }
    end
  end
end
