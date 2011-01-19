class SchedulesController < ApplicationController
  layout "app_without_sidebar"
  
  def index
    if current_subdomain
      tournament = Tournament.from_param(current_subdomain)
    end

    #get max && min date
    max  = Schedule.get_max_date(tournament)
    min = Schedule.get_min_date(tournament)

    @max_date = max[:match_on]
    @min_date = min[:match_on] 

    @schedule_date = Schedule.get_tomorrow_record(tournament)

    @schedule_date ||= max

    @schedules = Schedule.get_records_by_day(@schedule_date[:match_on], tournament)
  end

  def show
    current_date = params[:id].to_date
    date_type    = params[:date_type]
    
#    tournament = Tournament.find_by_url(current_subdomain)
    tournament = Tournament.find_by_url('itleague')

    if ('prev' == date_type)
      condition_str = "match_on < ?  AND steps.tournament_id = ? "
      order_str = "match_on DESC"
    elsif ('next' == date_type)
      condition_str = "match_on > ?  AND steps.tournament_id = ? "
      order_str = "match_on ASC"
    end
    
    @match_date = Schedule.find(:first,
                                  :joins => "INNER JOIN `steps`" +
                                              "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour') ",
                                  :conditions => [condition_str, current_date,  tournament.id],
                                  :order => order_str,
                                  :limit => 1
                                 )

    @schedules = Schedule.get_records_by_day(@schedule_date[:match_on], tournament)

    @schedules = Schedule.find(:all,
                                :select => "schedules.*, leagues.name AS league_name, leagues.short_name AS league_short_name",
                                :joins => "INNER JOIN `steps`" +
                                    "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour') " +
                                    "INNER JOIN `steps` AS leagues " +
                                      "ON (schedules.league_id = leagues.id AND leagues.type = 'StepLeague') ",
                                :conditions => ["match_on = ?  AND steps.tournament_id = ? ", @match_date.match_on,  tournament.id],
                                :include => [:hosts, :guests, :venue],
                                :order => "match_at ASC"
                               )
    respond_to  do |format|
      format.html {render :layout => false}
      format.json {render :json => {:data => render_to_string(:partial => "schedules/day", :layout => false, :object => @schedules), :current_date => @match_date[:match_on].to_s}}
    end

  end
end
