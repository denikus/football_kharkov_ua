class StepStage < Step
  has_steps :leagues, :tours
  belongs_to_step :season
end
