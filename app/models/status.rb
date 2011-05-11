class Status < ActiveRecord::Base
  has_one :post, :as => :resource, :dependent => :destroy
  
end
