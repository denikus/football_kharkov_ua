class SidebarBlockCell < ::Cell::Base
  helper UrlHelper
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

    if current_subdomain
      tournament = Tournament.from_param(current_subdomain)
    end

    #get max && min date
    max  = Schedule.get_max_date(tournament, true)
    min = Schedule.get_min_date(tournament, true)
    @max_date = max[:match_on]
    @min_date = min[:match_on]

    @schedules = Schedule.get_records_by_day(@max_date, tournament)

    render :locals => {:min_date => @min_date , :max_date => @max_date}, :layout => false


  end

  def advertisement
    render
  end
end