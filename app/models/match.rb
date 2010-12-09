class Match < ActiveRecord::Base
  #belongs_to :tour
  belongs_to :referee
  belongs_to :schedule
  
  has_many :competitors, :include => :football_players do
    [:hosts, :guests].each do |side|
      define_method(side){ load_target unless loaded?; target.find{ |s| s.side == side } }
    end
  end
  delegate :hosts, :guests, :to => :competitors
  
  has_many :match_events
  has_many :match_links
  
#  validates_presence_of :referee
  
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
    match_events.destroy_all if create_events
    competitors.each do |cmp|
      cmp.update_stats stats[cmp.side], create_events
    end
  end
  
  def hosts= team_id
    hosts.team_id = team_id
  end
  
  def guests= team_id
    guests.team_id = team_id
  end
  
  def football_player_numbers= number
    @football_player_numbers = number
  end
  
  def update_competitors
    [:hosts, :guests].each do |side|
      cmp = competitors.send(side)
      cmp.football_players = @football_player_numbers[side].collect do |(fid, number)|
        FootballPlayer.new :footballer_id => fid, :number => number unless number.empty?
      end.compact
    end
  end
  
  def date
    played_at.strftime('%Y-%m-%d')
  end
  
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
