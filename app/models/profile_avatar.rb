class ProfileAvatar < ActiveRecord::Base
  belongs_to :profile
  
  has_attachment :content_type => :image,
    :storage => :file_system,
    :max_size => 500.kilobytes,
    :resize_to => '200x320>',
    :path_prefix => "public/user",
    :partition => false
  
  validates_as_attachment
end
