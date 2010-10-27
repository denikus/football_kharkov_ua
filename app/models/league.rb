class League < ActiveRecord::Base
  belongs_to :stage
  has_many :tours
  has_many :schedules
  has_and_belongs_to_many :teams
  
  def stage_number
    stage.number
  end
  
  def table_set
    returning Tour::Table::Set.new do |set|
      tours.each{ |t| set << t }
      set.reverse!
    end
  end
end
