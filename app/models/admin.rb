class Admin < ActiveRecord::Base
  devise :database_authenticatable, :rememberable
  has_many :permissions
  
  named_scope :regular, {:conditions => {:super_admin => false}}
  
  def super_user; super_admin; end
  
end
