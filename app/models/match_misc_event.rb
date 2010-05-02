class MatchMiscEvent < ActiveRecord::Base
  has_one :match_event, :as => :event, :dependent => :destroy
end
