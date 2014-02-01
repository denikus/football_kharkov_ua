# -*- encoding : utf-8 -*-
class Post < ActiveRecord::Base
  belongs_to :resource, :polymorphic => true
  belongs_to :user, :foreign_key => :author_id
  belongs_to :tournament
 
  has_many :comments, :dependent => :delete_all
  has_many :subscribers
  has_many :users, :through => :subscribers

  validates_presence_of :author_id, :title

  scope :tournament, lambda{ |tournament_subdomain|
    unless (tournament_subdomain.nil? || tournament_subdomain.empty?)
      {:joins => "INNER JOIN tournaments ON (posts.tournament_id = tournaments.id) ", :conditions => ["tournaments.url = ?", tournament_subdomain]}
    end  
  }

  before_create :prepare_dates_and_url
  after_create :generate_short_link
  before_save :validate_resource


  STATUSES = [[:published, "Публиковать/Завершена"], [:updating, "Публиковать/Обновляется"]]

  def prepare_dates_and_url
    unless self.resource.class.name=='Status'
      self.url = dirify(self.title)
      self.url_year  = Time.now.strftime("%Y")
      self.url_month = Time.now.strftime("%m")
      self.url_day  = Time.now.strftime("%d")
    else
      self.url = self.resource.id
    end
  end

  def generate_short_link
    unless ['test', 'development'].include? Rails.env
      Bitly.use_api_version_3
      bitly = Bitly.new(BITLY[:username], BITLY[:api_key])
      unless self.resource.class.name=='Status'
        self.short_url = bitly.shorten("http://football.kharkov.ua/#{self.created_at.strftime('%Y')}/#{self.created_at.strftime('%m')}/#{self.created_at.strftime('%d')}/#{self.url}").short_url
      else
        self.short_url = bitly.shorten("http://football.kharkov.ua/statuses/#{self.resource.id}").short_url
      end
    end
    self.save!
  end

  def validate_resource
    if !self.resource.valid?
      return false
    end
  end

  def dirify(str)
    st = Russian.transliterate(str)
    st.gsub!(/(\s\&\s)|(\s\&amp\;\s)/, ' and ') # convert & to "and"
    st.gsub!(/\W/, ' ') #replace non-chars
    st.gsub!(/(_)$/, '') #trailing underscores
    st.gsub!(/^(_)/, '') #leading unders
    st.strip.gsub(/(\s)/,'-').downcase.squeeze('-')
  end
end
