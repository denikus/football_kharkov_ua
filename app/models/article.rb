class Article < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  has_one :post, :as => :resource, :dependent => :destroy
  has_one :article_image
  
  validates_presence_of :body

  def before_save
    self.body = Sanitize.clean(self.body, Sanitize::Config::FOOTBALL_ARTICLE)
  end
end
