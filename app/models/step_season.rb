class StepSeason < Step
  has_steps :stages
  
  alias_method :steps, :stages

  scope :by_tournament,  lambda {|tournament_id| where(:tournament_id => tournament_id).order("identifier ASC") }
end
