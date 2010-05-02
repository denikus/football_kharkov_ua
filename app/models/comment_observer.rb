class CommentObserver < ActiveRecord::Observer
  def after_create(model)
#    model.logger.info("Comment #{model.id} created" )

#    model.post.
    subscribers = Subscriber.find(:all,
                          :conditions => ["post_id = ? AND user_id != ? ", model.post.id, model.author_id],
                          :include => :user
                          )
    recipients = subscribers.collect{|x | x.user[:email]}
    unless recipients.empty?
#      model.logger.info("Comment #{recipients.to_s} created" )
      CommentNotify.deliver_new_comment_email(model.post, model, recipients)
    end  
  end
end
