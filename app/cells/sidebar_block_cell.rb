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
    @quick_results = QuickMatchResult.find(:all, :joins => "INNER JOIN tournaments ON (tournaments.id = quick_match_results.tournament_id)", :conditions =>["tournaments.url = ? AND match_on='2010-09-25'", @opts[:subdomain]], :order => "match_on DESC, id ASC", :limit => 11);
    # , :group => "quick_match_results.id"   
    render
  end

  def advertisement
    render
  end
end