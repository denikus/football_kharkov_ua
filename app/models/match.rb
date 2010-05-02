class Match < ActiveRecord::Base
  belongs_to :tour
  has_many :competitors
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
  
  def hosts
    competitors.find_by_side :hosts
  end
  
  def guests
    competitors.find_by_side :guests
  end
  
  def refresh_score!
    self.match_events.player.collect(&:event).select{ |e| e.event_type == :score }.inject({}) do |res, e|
      res[e.football_player.competitor] ||= 0
      res[e.football_player.competitor] += 1
      res
    end.each{ |c, s| c.update_attribute(:score, s) }
  end
  
  def score
    "#{hosts.score}:#{guests.score}"
  end
end
