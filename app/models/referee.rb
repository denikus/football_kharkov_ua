class Referee < ActiveRecord::Base
  has_and_belongs_to_many :matches
  
  def full_name
    [last_name, first_name, patronymic].join(" ")
  end
  
  alias_method :name, :full_name
end
