class CommentNotify < ActionMailer::Base
  def new_comment_email(post, comment, recipients)
      recipients recipients
      from "football.kharkov.ua@gmail.com"
      subject "Новый комментарий в статье: \"  #{post.title}\" "
      sent_on Time.now
      content_type "text/html"
      body :comment => comment, :post => post
  end

end
