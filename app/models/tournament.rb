class Tournament < ActiveRecord::Base
  has_many :seasons

  validates_presence_of :name, :url
  validates_uniqueness_of :name, :url

  def to_param
    url
  end
  
  def self.from_param(param)
    find_by_url!(param)
  end
end
