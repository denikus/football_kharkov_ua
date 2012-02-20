# -*- encoding : utf-8 -*-
class PhotoGallery < ActiveRecord::Base
  has_one :post, :as => :resource, :dependent => :destroy
  has_many :photos
 
end
