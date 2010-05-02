class Comment < ActiveRecord::Base
  belongs_to :user, :foreign_key => :author_id
  acts_as_nested_set
  
  validates_presence_of :body
  validates_presence_of :author_id
  validates_presence_of :post_id
end
