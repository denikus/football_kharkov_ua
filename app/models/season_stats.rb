class SeasonStats

  attr_reader :season_rate, :wins, :draws, :loses

  def initialize(team, season)
    @team = team
    @season = season

    @stats = team.get_schedule_for_season(season.id)

    @wins = 0
    @draws = 0
    @loses = 0

    if !@stats.nil? then
      @stats.each do |team_stat|
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



    total_games = @wins + @draws + @loses

    if total_games == 0 then
      @season_rate = nil
    else
      @season_rate = ((3 * @wins + @draws).to_f / total_games.to_f).to_f
    end

    @season_rate
  end

end