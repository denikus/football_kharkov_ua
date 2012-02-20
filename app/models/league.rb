# -*- encoding : utf-8 -*-
class League < ActiveRecord::Base
  belongs_to :stage
  has_many :tours
  has_many :schedules
  has_and_belongs_to_many :teams
  
  scope :for_table, :include => {:tours => {:matches => {:competitors => [:team, :stats, {:football_players => :stats}]}}}
  
  def stage_number
    stage.number
  end
  
  def table_set
    @table ||= returning(Tour::Table::Set.new) do |set|
      tours.each{ |t| set << t }
      set.each_with_index do |t, i|
        t.process
        next if i.zero?
        t.values.each_with_index do |record, position|
          record.position_change = set[i-1].values.index{ |v| v.team.id == record.team.id } - position
        end
      end
      set.reverse!
    end
  end
end
