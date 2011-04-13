class Footballer < ActiveRecord::Base
  #has_and_belongs_to_many :teams
  has_many :footballers_teams

  belongs_to :user
  #named_scope :by_team_season, lambda{ |options|
  #    {:joins => "INNER JOIN footballers_teams ON (footballers_teams.footballer_id=footballers.id)",
  #     :conditions => ["footballers_teams.season_id = ? AND footballers_teams.team_id = ?", options[:season_id], options[:team_id]],
  #     :order => "footballers.last_name ASC"}
  #}
  scope :by_team_step, lambda{ |options| {
    :joins => :footballers_teams,
    :conditions => {:footballers_teams => {:step_id => options[:step_id], :team_id => options[:team_id]}},
    :order => 'last_name ASC'
  } }

  before_save :prepare_data
  
  def full_name
    [last_name, first_name, patronymic].join(" ")
  end
  
  alias_method :name, :full_name

  def get_teams_seasons
    Footballer.find(:all,
        :select => "tournaments.name AS tournament_name, steps.name AS season_name, teams.name AS team_name, teams.url AS team_address",
        :joins => "INNER JOIN footballers_teams ON (footballers.id = footballers_teams.footballer_id) " +
                  "INNER JOIN teams ON (footballers_teams.team_id = teams.id) " +
                  "INNER JOIN steps ON (footballers_teams.step_id = steps.id AND steps.type = 'StepSeason') " +
                  "INNER JOIN tournaments ON (steps.tournament_id = tournaments.id)",
        :conditions => ["footballers_teams.footballer_id = ?", self.id]
       )


#    Tournament.find(:all,
#                    :select => "tournaments.name AS tournament_name, seasons.name AS season_name, teams.name AS team_name, teams.url AS team_address",
#                    :joins => "INNER JOIN seasons ON (seasons.tournament_id = tournaments.id) " +
#                              "INNER JOIN footballers_teams ON (footballers_teams.season_id = seasons.id) " +
#                              "INNER JOIN teams ON (footballers_teams.team_id = teams.id) ",
#                    :conditions => [" footballers_teams.footballer_id = ? ", self.id]
#            )
  end

  def prepare_data
    self.last_name.strip!
    self.first_name.strip!
    unless self.patronymic.nil?
      self.patronymic.strip!
    end  
    self.url = [self.last_name, self.first_name, self.patronymic].join("-")
  end
end
