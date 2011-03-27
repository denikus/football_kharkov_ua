class StepStage < Step
  has_steps :leagues, :tours
  belongs_to_step :season

  def is_playoff
    StepProperty.exists?(:step_id => self.id, :property_name => "IS_PLAYOFF", :property_value => "true")
  end

  def is_playoff= (is_playoff_flag)
    if is_playoff_flag
      if !is_playoff
        StepProperty.create(:step_id => self.id, :property_name => "IS_PLAYOFF", :property_value => "true")
      end
    else
      step_property = StepProperty.first(:conditions => {:step_id => self.id, :property_name => "IS_PLAYOFF"})
      StepProperty.delete(step_property.id)
    end
  end
end
