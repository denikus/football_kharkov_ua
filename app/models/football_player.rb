class FootballPlayer < ActiveRecord::Base
  STATS = %w{goal goal_10 goal_6 auto_goal yellow_card red_card}.freeze
  
  belongs_to :competitor
  belongs_to :footballer
  
  has_many :stats, :as => :statable, :extend => Stat::Ext, :dependent => :destroy
  
  def update stats
    self.number = stats['number']
    STATS.each{ |s| self.stats.set s, *stats[s].split(',').map(&:to_i) unless stats[s].empty? }
  end
  
  def match_id
    competitor.match_id
  end
  
  def to_tpl
    "#{footballer.first_name} #{footballer.last_name}"
  end
end
