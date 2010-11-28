class Tournament < ActiveRecord::Base
  has_many :step_seasons
  has_many :seasons
  has_many :posts
  
  alias_method :steps, :step_seasons

  validates_presence_of :name, :url
  validates_uniqueness_of :name, :url
  
  def phase_class_name
    'StepSeason'
  end

  def to_param
    url
  end
  
  class << self
    def from_param(param)
      find_by_url!(param)
    end
    
    alias_method :from, :from_param
  end
end