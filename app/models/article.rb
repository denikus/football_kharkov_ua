# -*- encoding : utf-8 -*-
class Article < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  has_one :post, :as => :resource, :dependent => :destroy
  has_one :article_image
  
  validates_presence_of :body

  before_save :sanitize_body
  

  def sanitize_body
    self.body = Sanitize.clean(self.body, Sanitize::Config::FOOTBALL_ARTICLE)
  end
end
