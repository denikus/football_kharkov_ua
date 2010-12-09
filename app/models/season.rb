class Season < ActiveRecord::Base
  belongs_to :tournament
  has_many :stages
  has_many :tour_results
  has_and_belongs_to_many :teams
  has_many :footballers, :through => :footballers_teams
  has_many :schedules

  named_scope :by_tournament, lambda{|tournament_id|  {:conditions => ["seasons.tournament_id = ?", tournament_id]}}

  def full_name
    [tournament.name, name] * ' '
  end

  def schedule_dates
    dates = []
    stages.each do |stage|
      stage.tours do |tour|
        dates << tour.schedules.collect(&:match_on).collect(&:strftime).uniq.sort
      end
    end
    dates.flatten!
  end

end
