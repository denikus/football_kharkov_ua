class MatchEvent < ActiveRecord::Base
  belongs_to :match
  belongs_to :match_event_type

  default_scope :order => 'minute ASC'

  
  def type
    match_event_type.symbol.to_sym
  end
end
