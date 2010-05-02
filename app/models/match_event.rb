class MatchEvent < ActiveRecord::Base
  belongs_to :match
  belongs_to :event, :polymorphic => true
  
  named_scope :player, {:conditions => "event_type = 'MatchPlayerEvent'", :include => :event}
end
