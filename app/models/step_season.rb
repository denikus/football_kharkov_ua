# -*- encoding : utf-8 -*-
class StepSeason < Step
  has_steps :stages
  has_many :footballers_teams
  alias_method :steps, :stages

  scope :by_tournament,  lambda {|tournament_id| where(:tournament_id => tournament_id).order("identifier ASC") }
  scope :by_footballer,  lambda {|footballer_id| joins("INNER JOIN `footballers_teams` ON (`footballers_teams`.step_id=`steps`.id)").where("`footballers_teams`.footballer_id = ? ", footballer_id) }
end
