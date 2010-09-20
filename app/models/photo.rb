class Photo < ActiveRecord::Base
  
  attr_accessor :file
  attr_accessor :user_id

  belongs_to :photo_gallery
  
  @@gallery_path       = ''
  @@gallery_thumb_path = ''
#  def initialize
    #create member's directory if not exists
#    @@gallery_path = RAILS_ROOT + '/public/member/' + Member.find(session['member_id']).login
#    self.prepare_directory(@@gallery_path)
    
    #create member's photo gallery directory if not exists    
#    @@gallery_path       = @@gallery_path + '/photo_gallery'
#    self.prepare_directory(@@gallery_path)
#  end
  
  def before_create
   self.save_to_gallery(self.file, self.filename, self.photo_gallery_id, self.user_id)
#      self.save
#    end
  end
  
  def save_to_gallery(file, filename, gallery_id, member_login)
    #!!!! move to initializer
    #@@gallery_path = RAILS_ROOT + '/public/member/' + Member.find(session['member_id']).login
    @@gallery_path = RAILS_ROOT + '/public/user/' + member_login

    self.prepare_directory(@@gallery_path)
    
    @@gallery_path       = @@gallery_path + '/photo_gallery'
    self.prepare_directory(@@gallery_path)
    
    #!!!!EOF move to initializer
    
    photo_path        = @@gallery_path + '/' + gallery_id.to_s + '/'
    photo_thumb_path  = photo_path + '/thumbs/' 
    #set pathes for gallery (user login)
    self.prepare_directory(photo_path)
    #and for thumbs
    self.prepare_directory(photo_thumb_path)

    picture = Picture.new
    picture.set_picture_path(photo_path)
    picture.set_thumb_path(photo_thumb_path)

    
    #save full photo
    picture.save(file)
    #save thumb
    picture.create_thumb(filename, 150,150)
  end
  
  protected
  
  def prepare_directory(directory_path)
    #create directory if not exists or exists but is not directory :)
    if !File.exists?(directory_path) || ( File.exists?(directory_path) && !File.directory?(directory_path) )
      Dir.mkdir(directory_path)
    end
  end
end

