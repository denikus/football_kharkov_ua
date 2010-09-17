class Team < ActiveRecord::Base
  attr_accessor :season_id
  
  has_many :footballers_teams, :include => :footballer do
    def footballers
      load_target unless loaded?
      target.collect(&:footballer)
    end
  end
  has_many :footballers, :through => :footballers_teams
  #has_and_belongs_to_many :footballers
  has_and_belongs_to_many :leagues
  has_and_belongs_to_many :seasons
  has_many :competitors, :dependent => :destroy
  
  def season_id= id
    @season_id = id
    set_footballer_ids if @footballer_ids
  end
  
  def footballer_ids
    footballers_teams.season(@season_id).footballers.collect(&:id)
  end
  
  def footballer_ids= ids
    @footballer_ids = ids.delete_if{ |id| id.empty? }
    set_footballer_ids if @season_id
  end
  
  def set_footballer_ids
    connection.execute("DELETE FROM footballers_teams WHERE season_id = #{@season_id} AND team_id = #{id}")
    @footballer_ids.each{ |id| footballers_teams.create(:footballer_id => id, :season_id => @season_id) }
  end
end
