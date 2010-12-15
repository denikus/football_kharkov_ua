class StepLeague < Step
  belongs_to_step :stage
  
  has_many :matches
  
  named_scope :for_table, :include => {:match => [{:schedule => :step_tour}, :step_league, {:competitors => [:team, :stats, {:football_players => :stats}]}]}
  
  def table_set
    @set ||= StepTour::Table::Set.new do |set|
      table = StepTour::Table.new
      matches.sort_by{ |m| m.schedule.match_on }.group_by{ |m| m.schedule.step_tour }.each do |tour, matches|
        matches.each{ |m| table << m }
      end
      set << table
    end
  end
end
