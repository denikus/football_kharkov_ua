class Article < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  has_one :post, :as => :resource, :dependent => :destroy
  has_one :article_image
  
  validates_presence_of :body
end
