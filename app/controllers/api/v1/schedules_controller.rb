class Api::V1::SchedulesController < Api::V1::BaseController
  before_filter :find_tournament

  def index
    ##get max && min date
    max  = Schedule.get_max_date(@tournament)
    min = Schedule.get_min_date(@tournament)
    #
    #@max_date = max[:match_on]
    #@min_date = min[:match_on]
    #
    @schedule_date = Schedule.get_tomorrow_record(@tournament)

    @schedule_date ||= max

    @schedules = []
    schedule = Schedule.get_records_by_day(@schedule_date[:match_on], @tournament)

    @schedules << schedule

    respond_to do |format|
      format.json{ render json: {schedules_count: @schedules.length, schedules: @schedules} }
    end
  end
end
