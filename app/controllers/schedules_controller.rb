class SchedulesController < ApplicationController
  layout "app_without_sidebar"
  
  def index
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
    if @dates.length==4
      @prev_date = @dates.delete_at(0).match_on
      @next_date = @dates.delete_at(2).match_on
    elsif @dates.length==3
      @prev_date = @dates.delete_at(0).match_on
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
    end


    #get prev and nex dates


    #fetch schedules by days
    @schedules = []
    i = 0
    @dates.each do |date_item|
      @schedules[i] = {}
      @schedules[i][:match_day] = date_item[:match_on]
      @schedules[i][:day_matches] = Schedule.find(:all,
                                  :conditions => ["match_on = ? AND season_id = ?  ", date_item[:match_on], @season.id],
                                  :include => [:quick_match_result, :hosts, :guests, :venue],
                                  :order => "match_at ASC"
                                 )
      i += 1
    end

  end

  def show
    match_on = params[:id].to_date
    @season = Season.find(:first,
                          :joins => :tournament,
                          :conditions => ["tournaments.url = ? ", current_subdomain],
                          :order => "seasons.id DESC"
                          )
    @schedule_day = {}
    @schedule_day[:match_day] = match_on
    @schedule_day[:day_matches] = Schedule.find(:all,
                                  :conditions => ["match_on = ? AND season_id = ?  ", match_on, @season.id],
                                  :order => "match_at ASC"
                                 )

#    ap next_date = Schedule.find(:first, :conditions => ["match_on > ? AND season_id = ?  ", match_on, @season.id], :order => "match_on ASC")
#    debugger

    if 'prev'==params[:date_type]
      @arrow_date = Schedule.find(:first,
                    :select => "match_on",
                    :conditions => ["match_on < ? AND season_id = ? ", match_on, @season.id],
                    :group => "match_on",
                    :order => "match_on DESC"
                    )
    elsif 'next'==params[:date_type]
      @arrow_date = Schedule.find(:first,
                    :select => "match_on",
                    :conditions => ["match_on > ? AND season_id = ? ", match_on, @season.id],
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
