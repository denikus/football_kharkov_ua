# -*- encoding : utf-8 -*-
class SchedulesController < ApplicationController
  layout "app_without_sidebar"
  
  def index
    unless request.subdomain.blank?
      tournament = Tournament.from_param(request.subdomain)
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
    
    tournament = Tournament.find_by_url(request.subdomain)

    if ('prev' == date_type)
      condition_str = "match_on < ?  AND #{(tournament.nil? ? "1" : "steps.tournament_id = ?")} "
      order_str = "match_on DESC"
    elsif ('next' == date_type)
      condition_str = "match_on > ?  AND #{(tournament.nil? ? "1" : "steps.tournament_id = ?")} "
      order_str = "match_on ASC"
    end

   unless tournament.blank?
      conditions = [condition_str, current_date,  tournament.id]
    else
      conditions = [condition_str, current_date]
    end
    
    @match_date = Schedule.find(:first,
                                  :joins => "INNER JOIN steps " +
                                              "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour') ",
                                  :conditions => conditions,
                                  :order => order_str,
                                  :limit => 1
                                 )
    @schedules_by_day = Schedule.get_records_by_day(@match_date[:match_on], tournament)
    
    unless tournament.blank?
      conditions = ["match_on = ?  AND steps.tournament_id = ? ", @match_date.match_on,  tournament.id]
    else
      conditions = ["match_on = ?", @match_date.match_on]
    end

    @schedules = Schedule.find(:all,
                                :select => "schedules.*, leagues.name AS league_name, leagues.short_name AS league_short_name",
                                :joins => "INNER JOIN steps " +
                                    "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour') " +
                                    "LEFT JOIN steps AS leagues " +
                                      "ON (schedules.league_id = leagues.id AND leagues.type = 'StepLeague') ",
                                :conditions => conditions,
                                :include => [:hosts, :guests, :venue],
                                :order => "match_at ASC"

                               )
    @current_date = @match_date[:match_on].to_s
    unless params[:format] == 'quick_results'
      @template_data = render_to_string(:partial => "day", :locals => {:schedules => @schedules})

      render :layout => false, :locals => {:current_date => @match_date[:match_on].to_s}
    else
      @template_data = render_to_string(:partial => "quick_results_day", :locals => {:schedules => @schedules})

      render :partial => "show_quick_results.js.haml", :locals => {:current_date => @match_date[:match_on].to_s}
    end
#    respond_to  do |format|
#      format.html {render :layout => false}
#      format.json {render :json => {:data => render_to_string(:partial => "schedules/day", :layout => false, :object => @schedules), :current_date => @match_date[:match_on].to_s}}
#    end

  end

  def update
    if !current_user.nil? && MEGA_USER.include?(current_user.id)
      schedule = Schedule.find(params[:id])
      score = params[:score].empty? ? nil : params[:score]
      if (params[:team_type]=='host')
        schedule.update_attribute('host_scores', score)
      elsif (params[:team_type]=='guest')
        schedule.update_attribute('guest_scores', score)
      end
      schedule.save!
    end

    respond_to  do |format|
      format.json {render :json => {:success => true}}
    end  
  end
end
