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

end
