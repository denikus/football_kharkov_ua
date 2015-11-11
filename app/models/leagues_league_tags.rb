class LeaguesLeagueTags < ActiveRecord::Base
  belongs_to :step_league, :foreign_key => 'step_league_id'
  belongs_to :league_tag
end
