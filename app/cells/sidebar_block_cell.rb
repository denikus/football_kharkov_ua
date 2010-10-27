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
    @season = Season.find(:first,
                          :joins => :tournament,
                          :conditions => ["tournaments.url = ? ", @opts[:subdomain]],
                          :order => "seasons.id DESC"
                          )  
    @last_date = Schedule.find(:first,
                               :joins => "INNER JOIN quick_match_results ON (quick_match_results.schedule_id = schedules.id) ", 
                               :conditions => ["quick_match_results.hosts_score IS NOT NULL AND quick_match_results.guests_score IS NOT NULL AND season_id = ? ", @season.id],
                               :order => "schedules.match_on DESC"
                               )
    unless  @last_date.nil?
      @schedules = Schedule.find(:all,
                                 :include => [:quick_match_result, :hosts, :guests],
                                 :conditions => ["schedules.match_on = ? ", @last_date[:match_on]],
                                 :order => "schedules.match_at ASC"
                                 )
    else
      @schedules = []
    end
    render
  end

  def advertisement
    render
  end
end