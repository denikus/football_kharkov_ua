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
  
  def to_tpl
    team.name
  end
end
