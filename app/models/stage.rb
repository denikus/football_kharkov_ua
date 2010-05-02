class Stage < ActiveRecord::Base
  belongs_to :season
  has_many :leagues
  
  def name
    [season.full_name, 'Этап', number] * ' '
  end
end
