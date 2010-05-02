class Page < ActiveRecord::Base
  validates_presence_of :title, :body

  def before_create
    @attributes['permalink'] = title.downcase.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_]+/, '')
  end
  
  def to_param
    "#{id}-#{permalink}"
  end
end
