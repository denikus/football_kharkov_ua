class Api::V1::ViolationsController < Api::V1::BaseController
  before_filter :find_tournament

  def index
    #get last season
    season =  Step.where("type = 'StepSeason' AND tournament_id = ?", @tournament.id).last

    violations = StepSeason.select("`stats`.id, `stats`.name as stats_name, footballers.first_name, footballers.last_name, teams.name, tours.name as tour_name ").joins(
                                                  "INNER JOIN `steps_phases` as s_p_stage " +
                                                    "ON (s_p_stage.step_id = steps.id) " +
                                                  "INNER JOIN `steps_phases` as s_p_tours " +
                                                    "ON (s_p_tours.step_id = s_p_stage.phase_id) " +
                                                  "INNER JOIN `steps` as tours " +
                                                    "ON (tours.id = s_p_tours.phase_id AND tours.type='StepTour') " +
                                                  "INNER JOIN `schedules` as s " +
                                                    "ON (s.tour_id = tours.id) " +
                                                  "INNER JOIN `matches` as matches " +
                                                    "ON (s.id = matches.schedule_id) " +
                                                  "INNER JOIN `competitors` " +
                                                    "ON (matches.id = competitors.match_id) " +
                                                  "INNER JOIN `teams` " +
                                                    "ON (competitors.team_id = teams.id) " +
                                                  "INNER JOIN `football_players` as f_p " +
                                                    "ON (competitors.id = f_p.competitor_id) " +
                                                  "INNER JOIN `footballers` " +
                                                    "ON (footballers.id = f_p.footballer_id) " +
                                                  "INNER JOIN `stats` " +
                                                    "ON (stats.statable_id = f_p.id AND stats.statable_type = 'FootballPlayer' AND stats.name IN ('yellow_card', 'red_card')) "
                                                 ).where(:id => season.id).group("tours.id, stats.id").order("tours.id DESC")
    @violations_by_tour = []
    i = 0
    violations.each do |item|
      i += 1 if !@violations_by_tour[i].nil? && item.tour_name != @violations_by_tour[i]["tour_name"]
      @violations_by_tour[i] = [] if @violations_by_tour[i].nil?
      @violations_by_tour[i] << {team_name: item.name, first_name: item.first_name, last_name: item.last_name, stats_name: item.stats_name, tour_name: item.tour_name}
    end

    respond_to do |format|
      format.json{ render json: {violations: @violations_by_tour} }
    end
  end

end
