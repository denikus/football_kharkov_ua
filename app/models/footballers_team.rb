class FootballersTeam < ActiveRecord::Base
  belongs_to :footballer
  belongs_to :team
  belongs_to :season
  
  validates_presence_of :season
  
  named_scope :season, lambda{ |season_id| {:conditions => {:season_id => season_id}} }
end
