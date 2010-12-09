class Team < ActiveRecord::Base
  #has_many :footballers_teams, :include => :footballer
  #has_many :footballers, :through => :footballers_teams
  #has_and_belongs_to_many :footballers
  #has_and_belongs_to_many :leagues
  #has_and_belongs_to_many :seasons
  has_many :competitors, :dependent => :destroy
  
  has_many :footballers_teams
  
  def footballer_ids
    @footballers_proxy ||= FootballersProxy.new self
  end

  def before_save
    self.url = self.name.gsub(/[^a-zA-Zа-яА-Я0-9\-]/, '-')
  end
  
  class FootballersProxy < ActiveSupport::BasicObject
    def initialize team
      @team = team
    end
    
    def [] step_id
      Footballer.by_team_step(:team_id => @team.id, :step_id => step_id).map(&:id)
    end
    
    def []= step_id, ids
      FootballersTeam.delete_all(:step_id => step_id)
      FootballersTeam.create ids.collect{ |id| {:step_id => step_id, :team_id => @team.id, :footballer_id => id} }
    end
  end
end
