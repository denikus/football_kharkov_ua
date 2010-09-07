class Tournament < ActiveRecord::Base
  has_many :seasons
  has_many :post

  validates_presence_of :name, :url
  validates_uniqueness_of :name, :url

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