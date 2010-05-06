class Match < ActiveRecord::Base
  belongs_to :tour
  
  has_many :competitors do
    [:hosts, :guests].each do |side|
      define_method(side){ to_a.find{ |s| s.side == side } }
    end
  end
  delegate :hosts, :guests, :to => :competitors
  
  has_many :match_events
  has_many :match_links
  
  def self.create_from_form params
    returning self.new(:tour_id => params[:tour_id],
      :referee_id => params[:referee_id],
      :played_at => DateTime.parse("#{params[:play_date]} #{params[:play_time]} +2000"),
      :match_type => params[:match_type],
      :period_duration => params[:period_duration],
      :comment => params[:comment]
    ) do |match|
      match.competitors = Competitor::SIDES.collect do |competitor_side|
        competitor = Competitor.new :side => competitor_side, :team_id => params[:competitors][competitor_side][:team_id].to_i, :score => 0
        competitor.football_players = params[:competitors][competitor_side][:football_players].collect do |footballer_id, footballer_params|
          FootballPlayer.new(:footballer_id => footballer_id.to_i, :number => footballer_params[:number].to_i) if footballer_params.key? :included
        end.compact
        competitor
      end
    end
  end
  
  def stats
    Competitor::SIDES.inject({}) do |res, c|
      res[c] = send(c).stats.inject({}){ |r, s| r[s.statistic.symbol.to_sym] = s.statistic_value; r }
      res[c][:football_players] = send(c).football_players.inject({}) do |re, f|
        re[f.id] = f.stats.inject(Hash.new{ |h, k| h[k] = [] }) do |r, s|
          r[s.statistic.symbol.to_sym] << s.statistic_value; r
        end
        re[f.id].each{ |s, v| re[f.id][s] = v.join(', ') }
        re[f.id][:number] = f.number
        re[f.id][:full_name] = ([f.footballer.last_name] + [f.footballer.first_name, f.footballer.patronymic].collect{ |n| n[0..0]+'.' unless n.empty? }.compact).join(' ')
        re
      end
      res
    end
  end
  
  def score
    "#{hosts.stats.score || 0}:#{guests.stats.score || 0}"
  end
end
