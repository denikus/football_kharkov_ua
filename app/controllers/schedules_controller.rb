class SchedulesController < ApplicationController
  layout "app_without_sidebar"
  
  def index
    tournament = Tournament.find(1)

    @dates = Schedule.paginate(
                               :select => "match_on",
                               :joins => "INNER JOIN `steps`" +
                                          "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",
                               :conditions => ["match_on >= ? AND steps.tournament_id = ? ", Time.now.to_date, tournament.id],
                               :group => "match_on",
                               :order => "match_on ASC",
                               :per_page => 2,
                               :page => 1
                               )
    
    prev_date = Schedule.find(:first,
                               :select => "match_on",
                               :joins => "INNER JOIN `steps`" +
                                          "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",

                               :conditions => ["match_on < ? AND steps.tournament_id = ? ", Time.now.to_date, tournament.id],
                               :group => "match_on",
                               :order => "match_on DESC",
                               :limit => 1
                               )
    @prev_date = prev_date.nil? ? nil : prev_date.match_on
    @next_date = nil
    if @dates.length==2
      @next_date = @dates.delete_at(2).match_on
    end

    if @dates.empty?
      @dates = Schedule.paginate(
                               :select => "match_on",
                               :joins => "INNER JOIN `steps`" +
                                  "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",
                               :conditions => ["steps.tournament_id = ? ", tournament.id],
                               :group => "match_on",
                               :order => "match_on DESC",
                               :per_page => 2,
                               :page => 1
                               )
      @dates.reverse!

      if @dates.length==2
        @prev_date = @dates.delete_at(0).match_on
      end
    
=begin

    @season = Season.find(:first,
                        :joins => :tournament,
                        :conditions => ["tournaments.url = ? ", current_subdomain],
                        :order => "seasons.id DESC"
                        )
    #get two latest dates from schedules
    @dates = Schedule.paginate(
                               :select => "match_on",
                               :conditions => ["match_on >= ? AND season_id = ? ", Time.now.to_date, @season.id],
                               :group => "match_on",
                               :order => "match_on ASC",
                               :per_page => 3,
                               :page => 1
                               )
    prev_date = Schedule.find(:first,
                               :select => "match_on",
                               :conditions => ["match_on < ? AND season_id = ? ", Time.now.to_date, @season.id],
                               :group => "match_on",
                               :order => "match_on DESC",
                               :limit => 1
                               )
    @prev_date = prev_date.nil? ? nil : prev_date.match_on
    @next_date = nil
    if @dates.length==3
      @next_date = @dates.delete_at(2).match_on
    end

    if @dates.empty?
      @dates = Schedule.paginate(
                               :select => "match_on",
                               :conditions => ["season_id = ? ", @season.id],
                               :group => "match_on",
                               :order => "match_on DESC",
                               :per_page => 3,
                               :page => 1
                               )
      @dates.reverse!
      
      if @dates.length==3
        @prev_date = @dates.delete_at(0).match_on
      end
=end
    end


    #get prev and nex dates


    #fetch schedules by days
    @schedules = []
    i = 0
    @dates.each do |date_item|
      @schedules[i] = {}
      @schedules[i][:match_day] = date_item[:match_on]
      @schedules[i][:day_matches] = Schedule.find(:all,
                                                  :select => "schedules.*, leagues.name AS league_name, leagues.short_name AS league_short_name", 
                                                  :joins => "INNER JOIN `steps`" +
                                                      "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour') " + 
                                                      "INNER JOIN `steps` AS leagues " +
                                                        "ON (schedules.league_id = leagues.id AND leagues.type = 'StepLeague') ",
                                                  :conditions => ["match_on = ?  AND steps.tournament_id = ? ",date_item[:match_on],  tournament.id],
                                                  :include => [:hosts, :guests, :venue],
                                                  :order => "match_at ASC"
                                                 )
      i += 1
    end

  end

  def show
    match_on = params[:id].to_date
#    tournament = Tournament.find_by_url(current_subdomain)
    tournament = Tournament.find_by_url('itleague')

    @schedule_day = {}
    @schedule_day[:match_day] = match_on
    @schedule_day[:day_matches] = Schedule.find(:all,
                                                :joins => "INNER JOIN `steps`" +
                                                    "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",
                                                :conditions => ["schedules.match_on = ? AND steps.tournament_id = ?  ", match_on, tournament.id],
                                                :order => "match_at ASC"
                                               )

#    ap next_date = Schedule.find(:first, :conditions => ["match_on > ? AND season_id = ?  ", match_on, @season.id], :order => "match_on ASC")
#    debugger

    if 'prev'==params[:date_type]
      @arrow_date = Schedule.find(:first,
                    :select => "match_on",
                    :joins => "INNER JOIN `steps`" +
                        "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",

                    :conditions => ["schedules.match_on < ? AND steps.tournament_id = ?  ", match_on, tournament.id],
                    :group => "match_on",
                    :order => "match_on DESC"
                    )
    elsif 'next'==params[:date_type]
      @arrow_date = Schedule.find(:first,
                    :select => "match_on",
                    :joins => "INNER JOIN `steps`" +
                        "ON (schedules.tour_id = steps.id AND steps.type = 'StepTour')",
                    :conditions => ["schedules.match_on > ? AND steps.tournament_id = ?  ", match_on, tournament.id],
                    :group => "match_on",
                    :order => "match_on ASC"
                    )

    end
    @arrow_date ||= ''

=begin

#    unless (next_date = Schedule.find(:first, :conditions => ["match_on > ? AND season_id = ?  ", match_on, @season.id], :order => "match_on ASC")).nil?
#      @dates = Schedule.paginate(
#                               :select => "match_on",
#                               :conditions => ["match_on <= ? AND season_id = ?", next_date.match_on, @season.id],
#                               :group => "match_on",
#                               :order => "match_on DESC",
#                               :per_page => 3,
#                               :page => 1
#                               )
#      @dates.reverse!
#      ap @dates
#    else
#      @dates = []
#      puts "---------------------------------------------"
#      puts "no data"
#      puts "---------------------------------------------"
#    end

=end
    respond_to  do |format|
      format.html {render :layout => false}
      format.json {render :json => {:data => render_to_string(:partial => "schedules/day", :layout => false, :locals => {:schedule_day => @schedule_day}), :arrow_date => @arrow_date[:match_on].to_s}}
    end

  end
end
