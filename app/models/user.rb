class User < ActiveRecord::Base
  has_one :profile

  has_many :comments
  has_many :subscribers
  has_many :posts, :through => :subscribers
  
  devise :all
  
  validates_presence_of :username
  validates_uniqueness_of :username, :case_sensitive => false
  validates_length_of :username, :within => 3..64
  validates_uniqueness_of :email, :case_sensitive => false
  
  def before_create
    self.profile = Profile.new
  end

  def after_create
    user_path = "#{RAILS_ROOT}/public/user"
    FileUtils.mkdir(user_path) unless File.exist?(user_path)
    FileUtils.mkdir(File.join(user_path, self.id.to_s)) unless File.exist?(File.join(user_path, self.id.to_s))
  end
  
  def to_param
    username
  end
  
  def self.from_param(param)
    find_by_username!(param)
  end
  
  def confirm_with_forum!
    ret = confirm_without_forum!
    Net::HTTP.post_form(URI.join(FORUM[:location], FORUM[:confirm_user]), {
      'from_rails' => 'true',
      'rails_secret' => FORUM[:secret],
      'Name' => username
    })
    ret
  end
  
  alias_method_chain :confirm!, :forum
  
end
