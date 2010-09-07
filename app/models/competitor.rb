class Competitor < ActiveRecord::Base
  belongs_to :match
  belongs_to :team
  has_many :football_players
  #has_many :stats, :as => :statable, :include => :statistic, :extend => Statistic::Ext
  has_many :stats, :as => :statable, :extend => [Stat::Ext, MatchEvent::Ext]
  #delegate :score, :to => :stats
  
  SIDES = [:hosts, :guests].freeze
  
  def update_stats params, create_events=false
    player_stats = params.delete :players
    [:first_period_fouls, :second_period_fouls, :score].each do |stat|
      params[stat] = 0 if params[stat].empty?
    end
    if create_events
      stats.with_events(:minute => match.period_duration).set('first_period_fouls', params[:first_period_fouls])
      stats.with_events(:minute => match.period_duration * 2).set('second_period_fouls', params[:second_period_fouls])
      stats.with_events(:minute => match.period_duration * 2).set('score', params[:score])
    else
      params.each{ |s, v| stats.set(s, v) }
    end
    if player_stats
      football_players.each do |fp|
        fp.update_stats player_stats[fp.footballer_id.to_s], create_events
      end
    end
  end
  
  def to_tpl
    team.name
  end
end
