class StepLeague < Step
  belongs_to_step :stage
  
  has_many :schedules, :foreign_key => 'league_id'
  has_many :matches, :through => :schedules
  
  named_scope :for_table, :include => {:matches => [{:schedule => :step_tour}, {:competitors => [:team, :stats, {:football_players => :stats}]}]}
  
  def table_set
    @set ||= StepTour::Table::Set.new do |set|
      table = StepTour::Table.new
      matches.sort_by{ |m| m.schedule.match_on }.group_by{ |m| m.schedule.step_tour }.each do |tour, matches|
        matches.each{ |m| table << m }
        set << table
      end
    end
  end
end
