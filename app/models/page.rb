class Page < ActiveRecord::Base
  validates_presence_of :title, :body

  belongs_to :tournament

#  def before_create
#    @attributes['permalink'] = title.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
#  end
  
  def to_param
    url
  end

  def self.from_param(param)
    find_by_url!(param)
  end
end
