class Stage < ActiveRecord::Base
  belongs_to :season
  has_many :leagues
  has_many :tours

  def name
    [season.full_name, 'Этап', number] * ' '
  end
  
  def self.create_next options
    number = first(:conditions => options, :order => 'number DESC').number rescue 0
    create(options.merge(:number => number + 1))
  end
end
