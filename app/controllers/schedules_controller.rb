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
                               :conditions => ["season_id = ? ", @season.id],
                               :group => "match_on",
                               :order => "match_on ASC",
                               :per_page => 3,
                               :page => 1
                               )
    #get prev and nex dates    
#    @next_date = nil
#    if @dates.length==3
#      @prev_date = @dates.delete_at(0).match_on
#    end
    #fetch schedules by days
=begin
    @schedules = []
    i = 0
    @dates.each do |date_item|
      @schedules[i] = {}
      @schedules[i][:match_day] = date_item[:match_on]
      @schedules[i][:day_matches] = Schedule.find(:all,
                                  :conditions => ["match_on = ? AND season_id = ?  ", date_item[:match_on], @season.id],
                                  :order => "match_at ASC"
                                 )
      i += 1
    end
=end

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

    render :layout => false
  end
end
