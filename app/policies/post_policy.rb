class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def update?
    user && (user.id == post.author_id || MEGA_USER.include?(user.id) )
  end

end
