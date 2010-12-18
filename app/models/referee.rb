class Referee < ActiveRecord::Base
  def full_name
    [last_name, first_name, patronymic].join(" ")
  end
  
  def name_with_initials
    returning last_name do |name|
      name << " #{last_name[/^(.)/, 1]}." if last_name
      name << " #{patronymic[/^(.)/, 1]}." if patronymic
    end
  end
  
  alias_method :name, :full_name
  
  has_and_belongs_to_many :matches
end
