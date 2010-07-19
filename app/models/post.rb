class Post < ActiveRecord::Base
  acts_as_taggable
  
  belongs_to :resource, :polymorphic => true
  belongs_to :user, :foreign_key => :author_id

  has_many :subscribers
  has_many :users, :through => :subscribers

  validates_presence_of :author_id, :title

  STATUSES = [[:published, "Публиковать/Завершена"], [:updating, "Публиковать/Обновляется"]]

  def before_create
    self.url = self.title.dirify
    Bitly.use_api_version_3
    bitly = Bitly.new(BITLY[:username], BITLY[:api_key])
    self.short_url = bitly.shorten(self.url)
  end

  def before_save
    if !self.resource.valid?
      return false
    end
  end
  
end
