class Competitor < ActiveRecord::Base
  belongs_to :match
  belongs_to :team
  has_many :football_players, :dependent => :destroy do
    def update_stats stats
      load_target unless loaded?
      stats = stats.clone
      target.each do |player|
        if stats[player.footballer_id.to_s]['number'].empty?
          delete player
        else

        end
      end
      stats.each do |id, s|
        next if s['number'].empty?
        player = target.find{ |p| p.footballer_id == id.to_i } || FootballPlayer.create(:footballer_id => id, :competitor_id => proxy_owner.id, :number => s['number'])
        player.update s
      end
    end
  end
  has_many :stats, :as => :statable, :extend => Stat::Ext, :dependent => :destroy

  scope :by_team_matches, lambda {|team_id, matches_id| where("team_id = ? AND match_id IN (?)", team_id, matches_id)}
  
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
