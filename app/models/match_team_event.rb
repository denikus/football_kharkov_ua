class MatchTeamEvent < ActiveRecord::Base
  has_one :match_event, :as => :event, :dependent => :destroy
  belongs_to :competitor
end
