class Match < ActiveRecord::Base
  belongs_to :tour
  
  has_many :competitors do
    [:hosts, :guests].each do |side|
      define_method(side){ target.find{ |s| s.side == side } }
    end
  end
  delegate :hosts, :guests, :to => :competitors
  
  has_many :match_events
  has_many :match_links
  
  def self.build_from_form params
    competitors = Competitor::SIDES.collect do |side|
      returning(Competitor.new :side => side, :team_id => params.delete(side)) do |cmp|
        cmp.football_players = params[:football_player_numbers][side].collect do |(fid, number)|
          FootballPlayer.new :footballer_id => fid, :number => number unless number.empty?
        end.compact
      end
    end
    params.delete :football_player_numbers
    (new params).tap{ |m| m.competitors = competitors }
  end
  
  def update_stats stats, create_events
    competitors.each do |cmp|
      cmp.update_stats stats[cmp.side], create_events
    end
  end
  
  #def stats
  #  Competitor::SIDES.inject({}) do |res, c|
  #    res[c] = send(c).stats.inject({}){ |r, s| r[s.statistic.symbol.to_sym] = s.statistic_value; r }
  #    res[c][:football_players] = send(c).football_players.inject({}) do |re, f|
  #      re[f.id] = f.stats.inject(Hash.new{ |h, k| h[k] = [] }) do |r, s|
  #        r[s.statistic.symbol.to_sym] << s.statistic_value; r
  #      end
  #      re[f.id].each{ |s, v| re[f.id][s] = v.join(', ') }
  #      re[f.id][:number] = f.number
  #      re[f.id][:full_name] = ([f.footballer.last_name] + [f.footballer.first_name, f.footballer.patronymic].collect{ |n| n[0..0]+'.' unless n.empty? }.compact).join(' ')
  #      re
  #    end
  #    res
  #  end
  #end
  
  def hosts_name
    hosts.team.name
  end
  
  def guests_name
    guests.team.name
  end
  
  def score
    "#{hosts.stats.get('score') || 0}:#{guests.stats.get('score') || 0}"
  end
end
