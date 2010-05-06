class Competitor < ActiveRecord::Base
  belongs_to :match
  belongs_to :team
  has_many :football_players
  has_many :stats, :as => :statable, :include => :statistic, :extend => Statistic::Ext
  delegate :score, :to => :stats
  
  SIDES = [:hosts, :guests].freeze
  
  def update_stats params
    params[:stats].each{ |s, v| stats.send(s+'=', v.to_i) }
    FootballPlayer.find(params[:football_players].keys).each do |fp|
      fp.update_stats(params[:football_players][fp.id.to_s][:stats])
    end
  end
end
