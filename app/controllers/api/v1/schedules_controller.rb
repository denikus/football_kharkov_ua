class Api::V1::SchedulesController < Api::V1::BaseController
  before_filter :find_tournament

  # get list of dates by season_url
  def index
    params[:season_url] ||= StepSeason.by_tournament(@tournament.id).last[:url]

    @season = StepSeason.by_tournament(@tournament.id).where(url: params[:season_url]).first

    # return error if no season with such url
    error!("Incorrect params", 403) and return if @season.nil?

    @dates = Schedule.select(:match_on).joins(
                    "INNER JOIN steps_phases AS tours_phase ON (tours_phase.phase_id = schedules.tour_id) " +
                    "INNER JOIN steps_phases AS seasons_phase ON (seasons_phase.phase_id = tours_phase.step_id) "
                   ).where("seasons_phase.step_id = ? ", @season.id).group("match_on").order("match_on ASC").collect{|item| item.match_on}

    respond_to do |format|
      format.json{ render json: {dates: @dates} }
    end
  end

  def show
    # return error if no season with such url
    error!("Incorrect params", 403) and return if params[:id].blank?

    #schedule Schedule.get_records_by_day(params[:id], @tournament).first

    @schedules = Schedule.get_records_by_day(params[:id], @tournament).collect{|item|
      {
        id: item.id,
        match_on: item.match_on,
        match_at: item.match_at,
        venue_name: (item.venue.nil? ? "" : item.venue.name),
        season_name: item.season_name,
        league_name: item.league_name,
        host_team_name: item.hosts.name,
        host_scores: item.host_scores,
        guest_team_name: item.guests.name,
        guest_scores: item.guest_scores
      }
    }


    respond_to do |format|
      format.json{ render json: {schedules_count: @schedules.length, schedules: @schedules} }
    end
  end
end
