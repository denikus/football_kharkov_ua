class LeagueTag < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :step_season, foreign_key: 'season_id'
  has_many :leagues_league_tags, class_name: 'LeaguesLeagueTags'
  has_many :step_leagues, through: :leagues_league_tags
end
