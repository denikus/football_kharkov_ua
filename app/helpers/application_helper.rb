# Methods added to this helper will be available to all templates in the application.
require "erb"
include ERB::Util

module ApplicationHelper

  def article_announce(body)
    unless (break_index = body.index('[[break]]')).nil?
      decode_entities(body[0..break_index-1])
    else
      truncate(decode_entities(body), 1000, '...')
    end
  end

  def full_article(body)
    decode_entities(body.sub(/\[\[break\]\]/, '<a href="#" id="announce-breaker"></a>'))
  end

  def show_comment(post, comment)
    unless post.hide_comments
      return comment.body
    end
    
    can_see = [post.author_id, comment.author_id]
    if user_signed_in? && can_see.include?(current_user[:id]) 
      return comment.body
    else
      return "<i>Комментарий скрыт</i>"
    end
  end

  def subscribed?(post_id)
    unless current_user[:id].nil?
      return !Subscriber.find(:first, :conditions => {:post_id => post_id, :user_id => current_user[:id]}).nil?
    else
      return false
    end
  end

  def retweet_button(title, link)
    bitly = Bitly.new(BITLY[:username], BITLY[:api_key])
    short_url = bitly.shorten(link)
    url_param = "Читаю: #{truncate(decode_entities(title), 109, '...')} #{short_url.bitly_url}"
    link_to image_tag("http://twitter-badges.s3.amazonaws.com/t_small-b.png", {:alt => "Retweet!"}), 'http://twitter.com/home?status=' + url_param, {:rel => "nofollow", :target => "_blank", :title => "Retweet!"} 
  end

  def to_facebook_button(title, link)
#    href = "http%3A%2F%2Fwww.dirjournal.com%2Farticles%2Fhow-to-add-a-twitter-button-to-your-blog-all-possible-options%2F&amp;t=How+to+Add+a+"
#&t=#{title}
    facebook_link = "http://www.facebook.com/sharer.php?u=#{url_encode(link)}"
    link_to image_tag("/images/icons/facebook_icon_24x24.png", {:alt => "Опубликовать на Facebook!"}), facebook_link, {:rel => "nofollow", :target => "_blank", :title => "Опубликовать на Facebook!"}
#    link_to "#{link}", url_encode(link),  {:rel => "nofollow", :target => "_blank", :title => "Опубликовать на Facebook!"}
  end
end
