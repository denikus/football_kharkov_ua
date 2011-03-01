class StepLeague < Step
  belongs_to_step :stage
  
  has_many :schedules, :foreign_key => 'league_id'
  has_many :matches, :through => :schedules
  
  named_scope :for_table, :include => {:matches => [{:schedule => :step_tour}, {:competitors => [:team, :stats, {:football_players => :stats}]}]}

  def StepLeague.get_leagues_in_season (season_id)
    leagues = self.find(:all,
              :select => "steps.* ",
              :joins => "INNER JOIN `steps_phases` AS stages_2_leagues " +
                          "ON (steps.id = stages_2_leagues.phase_id) " +
                        "INNER JOIN `steps_phases` AS seasons_2_stages " +
                          "ON (stages_2_leagues.step_id = seasons_2_stages.phase_id)" +
                        "INNER JOIN `steps` AS seasons " +
                          "ON (seasons_2_stages.step_id = seasons.id AND seasons.type = 'StepSeason')",
              :conditions => ["seasons.id = ? AND steps.type = 'StepLeague'", season_id])

    leagues
  end

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
