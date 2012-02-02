# -*- encoding : utf-8 -*-
class TourResult < ActiveRecord::Base
  has_one :post, :as => :resource, :dependent => :destroy
  belongs_to :season
end
