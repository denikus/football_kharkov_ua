class Post < ActiveRecord::Base
  acts_as_taggable
  
  belongs_to :resource, :polymorphic => true
  belongs_to :user, :foreign_key => :author_id
  belongs_to :tournament

  has_many :comments
  has_many :subscribers
  has_many :users, :through => :subscribers

  validates_presence_of :author_id, :title

  scope :tournament, lambda{ |tournament_subdomain|
    unless (tournament_subdomain.nil? || tournament_subdomain.empty?)
      {:joins => "INNER JOIN tournaments ON (posts.tournament_id = tournaments.id) ", :conditions => ["tournaments.url = ?", tournament_subdomain]}
    end  
  }

  STATUSES = [[:published, "Публиковать/Завершена"], [:updating, "Публиковать/Обновляется"]]

  def before_create
    self.url = self.title.dirify
    self.url_year  = Time.now.strftime("%Y")
    self.url_month = Time.now.strftime("%m")
    self.url_day  = Time.now.strftime("%d")
  end

  def after_create
    Bitly.use_api_version_3
    bitly = Bitly.new(BITLY[:username], BITLY[:api_key])
    self.short_url = bitly.shorten("http://football.kharkov.ua/#{self.created_at.strftime('%Y')}/#{self.created_at.strftime('%m')}/#{self.created_at.strftime('%d')}/#{self.url}").short_url
    self.save!
  end

  def before_save
    if !self.resource.valid?
      return false
    end
  end
  
end