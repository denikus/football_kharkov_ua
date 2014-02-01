# -*- encoding : utf-8 -*-
class StepLeague < Step
  belongs_to_step :stage
  
  has_many :schedules, :foreign_key => 'league_id'
  has_many :matches, :through => :schedules

  scope :for_table, :include => {:matches => [{:schedule => :step_tour}, {:competitors => [:team, :stats, {:football_players => :stats}]}]}

  def StepLeague.get_leagues_in_season(season_id)
    leagues = self.all(
              :select => "steps.* ",
              :joins => "INNER JOIN steps_phases AS stages_2_leagues " +
                          "ON (steps.id = stages_2_leagues.phase_id) " +
                        "INNER JOIN steps_phases AS seasons_2_stages " +
                          "ON (stages_2_leagues.step_id = seasons_2_stages.phase_id)" +
                        "INNER JOIN steps AS seasons " +
                          "ON (seasons_2_stages.step_id = seasons.id AND seasons.type = 'StepSeason')",
              :conditions => ["seasons.id = ? AND steps.type = 'StepLeague'", season_id])

    leagues
  end

  def StepLeague.exists?(season_id, league_name)
    self.where(:season_)
  end


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

  def is_bonus_point
    StepProperty.exists?(:step_id => self.id, :property_name => "IS_BONUS_POINT", :property_value => "true")
  end

  def is_bonus_point= (is_bonus_point_flag)
    if is_bonus_point_flag
      if !is_bonus_point
        StepProperty.create(:step_id => self.id, :property_name => "IS_BONUS_POINT", :property_value => "true")
      end
    else
      step_property = StepProperty.first(:conditions => {:step_id => self.id, :property_name => "IS_BONUS_POINT "})
      StepProperty.delete(step_property.id)
    end
  end
end
