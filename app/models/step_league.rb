class StepLeague < Step
  belongs_to_step :stage
  
  has_many :schedules, :foreign_key => 'league_id'
  has_many :matches, :through => :schedules
  
  def StepLeague.get_leagues_in_season (season_id)
    leagues = self.all(
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

  scope :for_table, :include => {:matches => [{:schedule => :step_tour}, {:competitors => [:team, :stats, {:football_players => :stats}]}]}

  def table_set
    @set ||= StepTour::Table::Set.new do |set|
      table = StepTour::Table.new
      matches.with_scores.sort_by{ |m| m.schedule.match_on }.group_by{ |m| m.schedule.step_tour }.each do |tour, matches|
#        if !schedule.host_scores.nil? && !schedule.guest_scores.nil?
          matches.each do |match|
#            if !match.schedule.host_scores.nil? && !match.schedule.guest_scores.nil?
              table << match
#            end
          end
          set << table
#        end
      end
    end
  end
  
  def last_table
    returning StepTour::Table.new do |table|
      matches.sort_by{ |m| m.schedule.match_on }.each{ |match| table << match }
      table.process
    end
  end
end
