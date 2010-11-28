class StepSeason < Step
  has_steps :stages
  
  alias_method :steps, :stages
end
