# -*- encoding : utf-8 -*-
class CommentNotify < ActionMailer::Base
  def new_comment_email(post, comment, recipient, recipients)
      recipients recipient
      bcc recipients
      from "football.kharkov.ua@gmail.com"
      subject "Новый комментарий в статье: \"  #{post.title}\" "
      sent_on Time.now
      content_type "text/html"
      body :comment => comment, :post => post
  end

end
