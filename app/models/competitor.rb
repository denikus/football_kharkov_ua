# -*- encoding : utf-8 -*-
class Competitor < ActiveRecord::Base
  belongs_to :match
  belongs_to :team

  after_create :create_resources

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
  has_many :football_player_appointments, :dependent => :destroy

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

  def create_resources
    FootballersTeam.find_all_by_team_id(self.team.id, :conditions => {:step_id => StepSeason.find_last_by_tournament_id(self.team.steps[0].tournament_id)}).each do |footballer_team|
      self.football_player_appointments.create(:competitor_id => self.id, :footballer_id => footballer_team.footballer_id)
    end
  end
end
