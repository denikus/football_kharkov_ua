# -*- encoding : utf-8 -*-
class CommentObserver < ActiveRecord::Observer
  def after_create(model)
#    model.logger.info("Comment #{model.id} created" )

#    model.post.
    subscribers = Subscriber.where(["post_id = ? AND user_id != ? ", model.post.id, model.author_id]).includes(:user).all
    recipients = subscribers.collect{|x | x.user[:email]}
    unless recipients.empty?
      recipient = recipients.pop
      #
      # model.logger.info("Comment #{recipients.to_s} created" )

      #CommentNotify.deliver_new_comment_email(model.post, model, recipient, recipients)
    end  
  end
end
