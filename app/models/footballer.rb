class Footballer < ActiveRecord::Base
  has_and_belongs_to_many :teams
  
  def full_name
    [last_name, first_name, patronymic].join(" ")
  end
end
