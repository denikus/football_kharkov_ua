class PhotoGallery < ActiveRecord::Base
  has_one :post, :as => :resource, :dependent => :destroy
 
end
