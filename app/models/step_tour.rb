class StepTour < Step
  belongs_to_step :stage
  
  has_many :matches
end
