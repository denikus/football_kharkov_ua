class SidebarBlockCell < ::Cell::Base
  def helpers

  end
  
  def news
    @posts = Post.tournament(@opts[:subdomain]).paginate(:page => 1, :per_page => 5, :order => 'created_at DESC')
    render
  end

  def comments
    @comments = Comment.tournament(@opts[:subdomain]).paginate(:page => 1, :per_page => 10, :order => 'created_at DESC', :include => {:post , :user}, :conditions => ["parent_id IS NOT NULL"])
    render
  end

  def shop
    render
  end

  def it_forecast
    render
  end

  def quick_results
    current_subdomain = @opts[:subdomain].nil? ? @opts[:locals][:current_subdomain] : @opts[:subdomain]

    #get current season for tournament    
    @season = Season.find(:first,
                          :joins => :tournament,
                          :conditions => ["tournaments.url = ? ", current_subdomain],
                          :order => "seasons.id DESC"
                          )

    if !@opts[:locals].nil? && @opts[:locals][:direction]=='prev'
      @last_dates = Schedule.find(:all,
                                  :joins => "INNER JOIN quick_match_results ON (quick_match_results.schedule_id = schedules.id) ",
                                  :conditions => ["quick_match_results.hosts_score IS NOT NULL AND quick_match_results.guests_score IS NOT NULL AND season_id = ?  AND schedules.match_on <= ? ", @season.id, @opts[:locals][:direction_date]],
                                  :group => "schedules.match_on",
                                  :order => "schedules.match_on DESC",
                                  :limit => 2
                                 )
      prev_date    = @last_dates[1].nil? ? '' : @last_dates[1].match_on
      current_date = @opts[:locals][:direction_date]
      next_date    = @opts[:locals][:current_date]
    elsif !@opts[:locals].nil? && @opts[:locals][:direction]=='next'
      @last_dates = Schedule.find(:all,
                                  :joins => "INNER JOIN quick_match_results ON (quick_match_results.schedule_id = schedules.id) ",
                                  :conditions => ["quick_match_results.hosts_score IS NOT NULL AND quick_match_results.guests_score IS NOT NULL AND season_id = ?  AND schedules.match_on >= ? ", @season.id, @opts[:locals][:direction_date]],
                                  :group => "schedules.match_on",
                                  :order => "schedules.match_on ASC",
                                  :limit => 2
                                 )
      prev_date    = @opts[:locals][:current_date]
      current_date = @last_dates[0].match_on
      next_date    = @last_dates[1].nil? ? '' : @last_dates[1].match_on
    else
      #get last two days with results
      @last_dates = Schedule.find(:all,
                                  :joins => "INNER JOIN quick_match_results ON (quick_match_results.schedule_id = schedules.id) ",
                                  :conditions => ["quick_match_results.hosts_score IS NOT NULL AND quick_match_results.guests_score IS NOT NULL AND season_id = ? ", @season.id],
                                  :group => "schedules.match_on",
                                  :order => "schedules.match_on DESC",
                                  :limit => 2
                                 )
      prev_date    = @last_dates[1].nil? ? '' : @last_dates[1].match_on
      current_date = @last_dates[0].match_on
      next_date    = ''
    end



    unless @last_dates.empty?
      @schedules = Schedule.find(:all,
                                 :include => [:quick_match_result, :hosts, :guests],
                                 :conditions => ["schedules.match_on = ? AND season_id = ? ", @last_dates[0][:match_on], @season.id],
                                 :order => "schedules.match_at ASC"
                                 )
    else
      @schedules = []
    end

    if @opts[:locals].nil?
      render :locals => {:prev_date => prev_date , :current_date => current_date, :next_date =>  next_date }, :layout => false
    else
      render :view => 'quick_results_content.haml', :locals => {:schedules => @schedules, :prev_date => prev_date , :current_date => current_date, :next_date =>  next_date }, :layout => false
    end
  end

  def advertisement
    render
  end
end