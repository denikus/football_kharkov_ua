class Picture
  require 'rubygems'
  require 'mini_magick'
  
  @@picture_path = ''
  @@thumb_path = ''
  
  def set_picture_path(path)
    @@picture_path = path
  end
  
  def set_thumb_path(path)
    @@thumb_path = path
  end

  def prepare_directory(directory_path)
    #create directory if not exists or exists but is not directory :)
    if !File.exists?(directory_path) || ( File.exists?(directory_path) && !File.directory?(directory_path) )
      Dir.mkdir(directory_path)
    end
  end
  
  def save(file)
    f = File.new(@@picture_path + file.original_filename, "w+")
    f.write file.read
    f.close
  end
  
  def destroy(filename)
    if (FileTest.exist?(File.expand_path(@@picture_path + filename))) 
      File.delete(File.expand_path(@@picture_path + filename))
    else 
     self.errors.add(:File, " not exists")
     return false
    end
  end
  
  def delete(files)
    files.each do |filename|
      if (FileTest.exist?(File.expand_path(@@picture_path + filename))) 
        File.delete(File.expand_path(@@picture_path + filename))
        self.delete_thumb('thumb_' + filename)
      end
    end
  end
  
  def delete_thumb(filename)
      if (FileTest.exist?(File.expand_path(@@thumb_path + filename))) 
        File.delete(File.expand_path(@@thumb_path + filename))
      end
  end
  
  def create_thumb(filename, max_width, max_height)
    #MiniMagick:
    image = MiniMagick::Image.from_file(File.expand_path(@@picture_path + filename))
    image.resize "150X150"
    thumbnail = File.open(@@thumb_path + 'thumb_' + filename, "wb+")
    image.write(thumbnail.path)
    return "thumb_" + filename.to_s
  end
  
  def remove_thumbs
    Dir.foreach(@@thumb_path) do |x| 
      if x != "." && x != ".." && x !=".svn" && x != "thumbs"
         File.delete(File.expand_path(@@thumb_path + x)) 
      end
    end
  end
end
