# -*- encoding : utf-8 -*-
class Admin < ActiveRecord::Base
  devise :database_authenticatable, :rememberable
  devise :encryptable, :encryptor => :sha1

  has_many :permissions
  
  scope :regular, -> {where(:super_admin => false)}
  
  def super_user; super_admin; end
  
end
