module ApplicationHelper

  def article_announce(body)
    if !(break_index = body.index('[[break]]')).nil?
      decode_entities(body[0..break_index-1])
    elsif !(break_index = body.index('<div style="page-break-after: always;">')).nil?
      decode_entities(body[0..break_index-1])
    else
      truncate(decode_entities(body), {:length => 1000, :omission =>  '...'})
    end
  end

  def full_article(body)
    new_body = body.sub(/\[\[break\]\]/, '<a href="#" id="announce-breaker"></a>')
#    decode_entities(new_body.sub(/<div style="page-break-after: always;">(.*?)<\/div>/m, '<a href="#" id="announce-breaker"></a>'))
    decode_entities(new_body.sub(/<div style="page-break-after: always;">(.*?)<\/div>/m, '<a href="#" id="announce-breaker"></a>'))
  end

  def show_comment(post, comment)
    unless post.hide_comments
      return simple_format(comment.body)
#      .gsub!(/\n/, '<br />')
    end

    can_see = [post.author_id, comment.author_id]
    if user_signed_in? && can_see.include?(current_user[:id])
      return comment.body
    else
      return "<i>Комментарий скрыт</i>".html_safe
    end
  end

  def subscribed?(post_id)
    unless current_user[:id].nil?
      return !Subscriber.find(:first, :conditions => {:post_id => post_id, :user_id => current_user[:id]}).nil?
    else
      return false
    end
  end

  def post_item_path(post_item, with_anchor =false)
    post_url({:year => post_item.url_year,
               :month => post_item.url_month,
               :day => post_item.url_day,
               :url => !post_item.url.nil? ? post_item.url : '',
               :anchor => with_anchor ? "announce-breaker" : "",
               :host => with_subdomain(post_item.tournament.nil? ? false : post_item.tournament.url)
#               :host => (post_item.tournament.nil? ? false : post_item.tournament.url)
              })
  end
=begin

  def social_button(type, title, link)
    result = case type
      when 'twitter' then
        bitly = Bitly.new(BITLY[:username], BITLY[:api_key])
        url = "Читаю: #{truncate(decode_entities(title), 109, '...')} #{bitly.shorten(link).bitly_url}"
        link_to image_tag("http://twitter-badges.s3.amazonaws.com/t_small-b.png", {:alt => "Retweet"}), 'http://twitter.com/home?status=' + url, {:rel => "nofollow", :target => "_blank", :title => "Retweet"}
    when 'facebook' then
      url = "http://www.facebook.com/sharer.php?u=#{url_encode(link)}&t=#{title}"
      link_to image_tag("/images/icons/facebook_icon_24x24.png", {:alt => "Опубликовать на Facebook"}), url, {:rel => "nofollow", :target => "_blank", :title => "Опубликовать на Facebook"}
    when 'vkontakte' then
      url = "http://vkontakte.ru/share.php?url=#{url_encode(link)}"
      link_to image_tag("/images/icons/vkontakte_icon_32x32.png", {:alt => "Опубликовать на Вконтакте", :size => "23x22"}), url, {:rel => "nofollow", :target => "_blank", :title => "Опубликовать на Вконтакте"}
    end
  end
=end

  def retweet_button(title, link)
    unless link.nil?
      #      Bitly.use_api_version_3
      #      bitly = Bitly.new(BITLY[:username], BITLY[:api_key])
      #      short_url = bitly.shorten(link)
      url = "Читаю: #{truncate(decode_entities(title), {:length =>109, :omission => '...'})} #{link}"
      link_to(image_tag("http://twitter-badges.s3.amazonaws.com/t_small-b.png", {:alt => "Retweet"}), "http://twitter.com/home?status=#{url}", {:rel => "nofollow", :target => "_blank", :title => "Retweet"})
    else
      ''
    end
  end

  def to_facebook_button(title, link)
    url = "http://www.facebook.com/sharer.php?u=#{url_encode(link)}&t=#{title}"
    link_to(image_tag("/images/icons/facebook_icon_24x24.png", {:alt => "Опубликовать на Facebook"}), url, {:rel => "nofollow", :target => "_blank", :title => "Опубликовать на Facebook"})
  end

  def to_vkontakte_button(title, link)
    url = "http://vkontakte.ru/share.php?url=#{url_encode(link)}"
    link_to(image_tag("/images/icons/vkontakte_icon_32x32.png", {:alt => "Опубликовать на Вконтакте", :size => "23x22"}), url, {:rel => "nofollow", :target => "_blank", :title => "Опубликовать на Вконтакте"})
  end

  def my_data?(user_id)
    user_signed_in? && current_user.id == user_id
  end

  def admin_top_menu
    tabs = [[:main, 'Главная', admin_root_path],
      [:content, 'Контент', admin_comments_path],
      [:personnel, 'Личный Состав', admin_teams_path],
      [:tournaments, 'Чемпионаты', admin_tournaments_path],
      [:permissions, 'Администрация', admin_permissions_path]]

    current_tab = controller.instance_variable_get('@admin_section') || controller.class.instance_variable_get('@admin_section')
    content_tag :ul, :id => 'top-navigation' do
      tabs.collect do |(tab, name, path)|
        content_tag(:li, :class => tab == current_tab ? 'active' : '') do
          content_tag :span do
            content_tag :span, tab == current_tab ? name : link_to(name, path)
          end
        end
      end
    end
  end

  def admin_sidebar
    case controller.instance_variable_get('@admin_section') || controller.class.instance_variable_get('@admin_section')
    when :personnel: render(:partial => 'admin/shared/personnel_sidebar')
    when :tournaments: render(:partial => 'admin/shared/tournaments_sidebar')
    end
  end

  def admin_title title
    render :partial => 'admin/shared/title', :object => title
  end

  def selection *args, &block
    #source = options[:on] or raise ArgumentError
    #collection = source.send(method)
    options = args.extract_options!
    name, method = args
    source = options[:on]
    collection = options[:collection] || (source.send(method) rescue raise ArgumentError)
    html = @template.content_tag(:div, :id => dom_id(source), :style => ("display: none;" unless options[:root])) do
      @template.content_tag(:span, name + ': ', :style => 'font-weight:bold;') +
      collection.collect do |element|
        h = block_given? ? link_to_function(element.name){ |p| p[dom_id(element)].show.siblings('div').hide } :
          options[:click] ? link_to_function(element.name, options[:click][element]) : element.name
        @template.content_tag(:span, h)
      end.join(' | ') +
      if block_given?
        collection.collect do |element|
          @template.capture(element, &block)
        end.join
      else; ''
      end
    end
    @template.concat html
  end

  def quick_match_result_formatted(match_item)
    winner_class = "winner"
    loser_class = "loser"
    hosts_class = guests_class = ""
    if match_item.hosts_score > match_item.guests_score
      hosts_class = winner_class
      guests_class = loser_class
    elsif match_item.hosts_score < match_item.guests_score
      hosts_class = loser_class
      guests_class = winner_class
    end
    return "<span class=\"#{hosts_class}\">#{match_item.hosts}</span> <span class=\"score\"></span> : <span class=\"score\"></span> <span class=\"#{guests_class}\">#{match_item.guests}</span>".html_safe
  end

  def post_belongs_2_subdomain?
    if !params.nil? && params[:controller] == "post" && !Post.find_by_url(params[:url]).nil?
      !Post.find_by_url(params[:url]).tournament.nil? ? true : false
    else
      return false
    end
  end

  def post_subdomain
    if !params.nil? && params[:controller] == "post" && !Post.find_by_url(params[:url]).nil?
      Post.find_by_url(params[:url]).tournament.url
    else
      false
    end
  end

  def current_subdomain
    request.subdomain.empty? ? nil : request.subdomain
  end
  
end
