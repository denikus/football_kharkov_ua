class MatchPlayerEvent < ActiveRecord::Base
  has_one :match_event, :as => :event, :dependent => :destroy
  belongs_to :football_player
  
  def after_save
#    match_event.match.refresh_score! if event_type == :score
  end
  
  def before_destroy
    @match = match_event.match
  end
  
  def after_destroy
#    @match.refresh_score! if event_type == :score
  end
  #named_scope :score, {:conditions => {:event_type => :score}, :include => {:football_player => :competitor}}
end
