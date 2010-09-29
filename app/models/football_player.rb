class FootballPlayer < ActiveRecord::Base
  belongs_to :competitor
  belongs_to :footballer
  
  has_many :stats, :as => :statable, :extend => [Stat::Ext, MatchEvent::Ext], :dependent => :destroy
  #has_many :stats, :as => :statable, :include => :statistic, :extend => [Statistic::Ext, MatchEvent::Ext]
  #has_many :stats, :as => :statable, :include => :statistic, :extend => Statistic::Ext
  
  #def update_stats params, create_events=false
  #  #params.each{ |s, v| stats.send(s+'=', v.split(/,\s?/).delete_if{ |e| e == '-' }.collect(&:to_i)) }
  #  obj = create_events ? stats.with_events(:team => competitor.team.name, :minute => :stat) : stats
  #  params.each do |name, value|
  #    puts name, value
  #    next if value.empty?
  #    st = value.split(/,\s*/).collect(&:to_i)
  #    obj.__send__(:"#{name}=", *st) unless value.empty?
  #  end
  #end

  def update_stats params, create_events=false
    #obj = create_events ? stats.with_events(:team => competitor.team.name, :minute => :stat) : stats
    #params.each do |name, value|
    #  next if value.empty?
    #  st = value.split(/,\s*/).collect(&:to_i)
    #  obj.set(name, *st)
    #end
    params.each do |s, v|
      params.delete(s) and next if v.empty?
      params[s] = v.split(/,\s*/).collect(&:to_i)
    end
    if create_events
      stats.with_events(:team => competitor.team.name, :minute => :stat).set('goal', *params[:goal]) if params.key? :goal
      stats.with_events(:minute => :stat).set('red_card', *params[:red_card]) if params.key? :red_card
    else
      params.each{ |s, v| stats.set(s, *v) }
    end
  end
  
  def match_id
    competitor.match_id
  end
  
  def to_tpl
    "#{footballer.first_name} #{footballer.last_name}"
  end
end
