class Match < ActiveRecord::Base
  belongs_to :schedule
  
  has_many :competitors, :include => :football_players do
    def [] side
      load_target unless loaded?
      target.find{ |s| s.side == side.to_sym }
    end
  end
  
  def hosts; competitors[:hosts]; end
  def guests; competitors[:guests]; end
  
  has_many :match_events
  has_many :match_links

  has_and_belongs_to_many :referees
  
  def generate_events
    MatchEvent.delete_all ['match_id = ? AND match_event_type_id IS NOT NULL', id]
    competitors.each do |cmp|
      cmp.generate_events
      cmp.football_players.each &:generate_events
    end
  end

  def date
    schedule.match_on.strftime('%Y-%m-%d')
  end
  
  def hosts_name
    hosts.team.name
  end
  
  def guests_name
    guests.team.name
  end
  
  def score
    "#{schedule.host_scores || 0}:#{schedule.guest_scores || 0}"
  end

  def has_protocol?
    return true
  end
end
