# -*- encoding : utf-8 -*-
class UserConnectFootballerRequest < ActiveRecord::Base
  has_attached_file :photo, :path => ":rails_root/public/:class/:attachment/:id/:style_:basename.:extension"

  belongs_to :footballer
  belongs_to :user
end
