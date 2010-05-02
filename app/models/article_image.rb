class ArticleImage < ActiveRecord::Base
require 'mini_magick'

  attr_accessor :source_path

  def initializer(params)
    self.source_path = params[:source_path]
    self.file        = params[:file]
    self.title       = params[:title]
    
#    @file_path = param[:source_path]
  end

  def before_update
    old_file = ArticleImage.find(self.id)
    if old_file.file != self.file
      old_file_path = RAILS_ROOT + "/public/images/articles/#{self.article.post.created_at.strftime("%Y-%m-%d")}/"
      if (FileTest.exist?(File.expand_path(old_file_path + old_file.file)))
        File.delete(File.expand_path(old_file_path + old_file.file))
      end
      prepare_directory(old_file_path)
      resize( self.source_path + self.file, old_file_path, 200, 200)
    end
  end

  def before_create
    folder_name = self.article.post.nil? ? Time.now.strftime("%Y-%m-%d").to_s : self.article.post.created_at.strftime("%Y-%m-%d").to_s
    
      picture_path = RAILS_ROOT + "/public/images/articles/#{folder_name}/"

    prepare_directory(picture_path)
    resize( self.source_path + File.basename(self.file), picture_path, 200, 200)
#    self.file = self.file
  end

  private

  def prepare_directory(directory_path)
    #create directory if not exists or exists but is not directory :)
    if !File.exists?(directory_path) || ( File.exists?(directory_path) && !File.directory?(directory_path) )
      Dir.mkdir(directory_path)
#      FileUtils.mkdir_p(directory_path)

    end
  end

  def resize(source_file, destination_folder, to_width, to_height)
    image = MiniMagick::Image.from_file(File.expand_path(source_file))

    dim_w = image[:width] >= image[:height] ? to_width : (image[:width] * to_width.to_f / image[:height]).to_i
    dim_h = image[:width] <= image[:height] ? to_height : (image[:height] * to_height.to_f / image[:width]).to_i
    image.resize "#{dim_w}x#{dim_h}" if image[:width] > dim_w or image[:height] > dim_h

    destination_image = File.open(destination_folder + self.file, "wb+")
    image.write(destination_image.path)
    destination_image.close
  end
end
