# -*- encoding : utf-8 -*-
require 'rss'
class SidebarBlockCell < ::Cell::Base
  helper UrlHelper
  helper ApplicationHelper
  include Devise::Controllers::Helpers

  def news(opts)
    @posts = Post.tournament(opts[:subdomain]).paginate(:page => 1, :per_page => 5, :order => 'created_at DESC')
    @opts = opts
    @domain= opts[:domain]
    render
  end

  def comments(opts)
    # http://football-kharkov-ua.disqus.com/latest.rss

    rss = RSS::Parser.parse('https://football-kharkov-ua.disqus.com/latest.rss', false)
    @comments = []
    #
    rss.items.each do |item|
      # puts "#{item.pubDate} - #{item.title}"
      # ap item.dc_creator
      @comments << {title: item.title, link: item.link, date: item.date, author: item.dc_creator}
    end

    # ap comments


    # @comments = []
    # @comments = Comment.tournament(opts[:subdomain]).paginate(:page => 1, :per_page => 10, :order => 'created_at DESC', :include => [:post , :user], :conditions => ["parent_id IS NOT NULL"])
    @opts = opts
    @domain= opts[:domain]
    render
  end

  def user_comments(args)
    @opts = args
    username = args[:user_id].nil? ? current_user.username : args[:user_id]
    user = User.from_param(username)
    @domain= args[:domain]
    @comments = Comment.tournament(args[:subdomain]).paginate(:page => 1, :per_page => 10, :order => 'created_at DESC', :include => [:post , :user], :conditions => ["comments.author_id = #{user.id} AND parent_id IS NOT NULL"])

    render :file => 'app/cells/sidebar_block/comments'
  end

  def shop(opts)
    @opts = opts
    render
  end

  def it_forecast
    render
  end

  def itleague_soc(opts)
    @opts = opts
    render
  end

  def quick_results(opts)
    subdomain = opts[:subdomain]
    if !subdomain.nil? && !subdomain.empty?
      tournament = Tournament.from_param(subdomain)
    end
    @opts = opts
    ##get max && min date

    max  = Schedule.get_max_date(tournament, true)
    min = Schedule.get_min_date(tournament, true)

    @max_date = max[:match_on]
    @min_date = min[:match_on]

    @schedules = Schedule.get_records_by_day(@max_date, tournament)

    render :locals => {:min_date => @min_date , :max_date => @max_date}, :layout => false
  end

  def footballer_matches

    @schedules = Schedule.future_footballer_matches(@footballer.id)
    render
  end

  def advertisement(opts)
    @opts = opts
    render
  end
end
