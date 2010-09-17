class Season < ActiveRecord::Base
  belongs_to :tournament
  has_many :stages
  has_many :tour_results
  has_and_belongs_to_many :teams

  def full_name
    [tournament.name, name] * ' '
  end
end
