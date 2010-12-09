class Referee < ActiveRecord::Base
  def full_name
    [last_name, first_name, patronymic].join(" ")
  end
  
  alias_method :name, :full_name
end
