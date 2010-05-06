class FootballPlayer < ActiveRecord::Base
  belongs_to :competitor
  belongs_to :footballer
  
  has_many :stats, :as => :statable, :include => :statistic, :extend => Statistic::Ext
  
  def update_stats params
    params.each{ |s, v| stats.send(s+'=', v.split(/,\s?/).delete_if{ |e| e == '-' }.collect(&:to_i)) }
  end
end
