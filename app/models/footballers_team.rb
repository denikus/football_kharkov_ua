class FootballersTeam < ActiveRecord::Base
  belongs_to :footballer
  belongs_to :team
  belongs_to :step
end
