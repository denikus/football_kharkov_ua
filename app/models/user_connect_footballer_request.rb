class UserConnectFootballerRequest < ActiveRecord::Base
  has_attached_file :photo

  belongs_to :footballer
  belongs_to :user
end
