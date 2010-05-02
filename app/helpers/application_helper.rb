# Methods added to this helper will be available to all templates in the application.
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
end
