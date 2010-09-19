class Season < ActiveRecord::Base
  belongs_to :tournament
  has_many :stages
  has_many :tour_results
  has_and_belongs_to_many :teams
  has_many :footballers, :through => :footballers_teams

  named_scope :by_tournament, lambda{|tournament_id|  {:conditions => ["seasons.tournament_id = ?", tournament_id]}}

  def full_name
    [tournament.name, name] * ' '
  end
end
