# -*- encoding : utf-8 -*-
class SeasonStats

  attr_reader :season_rate, :wins, :draws, :loses, :bonus_points

  def initialize(team, season)
    @team = team
    @season = season

    @stats = team.get_schedule_for_season(season.id)

    @wins = 0
    @draws = 0
    @loses = 0

    if !@stats.nil? then
      @stats.each do |team_stat|
        if(!team_stat.host_scores.nil? && !team_stat.host_scores.nil?)
          if team_stat.host_scores == team_stat.guest_scores
            @draws += 1
          elsif team_stat.host_scores > team_stat.guest_scores
            if team_stat.host_team_id == team.id
              @wins += 1
            else
              @loses += 1
            end
          else
            if team_stat.guest_team_id == team.id
              @wins += 1
            else
              @loses += 1
            end
          end
        end
      end
    end

    @bonus_points = 0

    leagues = team.steps.select{|step| step.is_a? StepLeague}

    leagues.each do |league|
      if league.stage.season == season && league.is_bonus_point
        @bonus_points += 1
      end
    end

    total_games = @wins + @draws + @loses

    if total_games == 0 then
      @season_rate = nil
    else
      @season_rate = ((2 * @wins + @draws + @bonus_points).to_f / total_games.to_f).to_f
    end

    @season_rate
  end

end
