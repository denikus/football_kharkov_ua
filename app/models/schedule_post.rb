class SchedulePost < ActiveRecord::Base
  has_one :post, :as => :resource, :dependent => :destroy

  def before_save
    self.generated_body = generate_schedule_widget(body) 
  end

  private

  def generate_schedule_widget(body)
    
  end
end
