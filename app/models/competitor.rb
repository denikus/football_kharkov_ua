class Competitor < ActiveRecord::Base
  belongs_to :match
  belongs_to :team
  has_many :football_players, :dependent => :destroy do
    def update_stats stats
      load_target unless loaded?
      stats = stats.clone
      target.each{ |player| delete player if stats[player.footballer_id.to_s]['number'].empty? }
      stats.each do |id, s|
        next if s['number'].empty?
        player = target.find{ |p| p.footballer_id == id.to_i } || FootballPlayer.new(:footballer_id => id, :competitor_id => proxy_owner.id)
        player.update s
      end
    end
  end
  has_many :stats, :as => :statable, :extend => Stat::Ext, :dependent => :destroy
  
  SIDES = [:hosts, :guests].freeze
  STATS = %w{score first_period_fouls second_period_fouls}.freeze
  
  def generate_events
    # WARNING: HARDCODE
    MatchEventType['first_period_fouls'].events.add(:match_id => match_id, :minute => 25, :owner => self, :stat => stats.get('first_period_fouls')) unless MatchEventType['first_period_fouls'].nil?
    MatchEventType['second_period_fouls'].events.add(:match_id => match_id, :minute => 50, :owner => self, :stat => stats.get('second_period_fouls')) unless MatchEventType['second_period_fouls'].nil?
    MatchEventType['score'].events.add(:match_id => match_id, :minute => 50, :owner => self, :stat => stats.get('score')) unless MatchEventType['score'].nil?
  end
  
  def to_tpl
    team.name
  end
end
