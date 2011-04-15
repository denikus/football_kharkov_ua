class FootballPlayer < ActiveRecord::Base
  STATS = %w{goal goal_10 goal_6 auto_goal yellow_card red_card missed_goal_6 missed_goal_10}.freeze
  
  belongs_to :competitor
  belongs_to :footballer
  
  has_many :stats, :as => :statable, :extend => Stat::Ext, :dependent => :destroy

  scope :sort_by_number, :order => "number ASC"
  scope :by_competitor_footballer, lambda {|competitors_id, footballer_id| where("competitor_id IN (?) AND footballer_id = ? ", competitors_id, footballer_id)}

  def update stats
    #check stats and create keys for missed_goal_10, missed_goal_6 if needed
    full_stats = {}
    stats.each do |key, val|
      penalty = {}
      if ["goal_10", "goal_6"].include?(key)
        penalty[key] = {:missed => [], :hit => []}
        val.split(",").each do |stat_item|
          if !stat_item.index("--").nil?
            penalty[key][:missed] << stat_item.to_i
          else
            penalty[key][:hit] << stat_item.to_i
          end
        end
        full_stats["missed_#{key}"] = penalty[key][:missed].join(",")
        full_stats[key] = penalty[key][:hit].join(",")
      else
        full_stats[key] = val
      end
    end
    
    self.number = stats['number']
    STATS.each{ |s| self.stats.set s, *full_stats[s].split(',').map(&:to_i) unless full_stats[s].empty? }
  end

  def self.get_stats(ids)
    FootballPlayer.select("COUNT(*), `stats`.name").
                   joins("INNER JOIN `stats` ON (`stats`.statable_id = `football_players`.id AND `stats`.statable_type = 'FootballPlayer')").
                   where("`football_players`.id IN (?)", ids).
                   group("`stats`.name")

  end

  def match_id
    competitor.match_id
  end
  
  def generate_events
    stats.all(
      :joins => 'JOIN match_event_types ON stats.name = match_event_types.symbol'
    ).each do |stat|
      MatchEventType[stat.name].events.add \
        :match_id => match_id,
        :minute => stat.value,
        :owner => self,
        :team => competitor
    end
  end
  
  def to_tpl
    "#{footballer.first_name} #{footballer.last_name}"
  end
end
