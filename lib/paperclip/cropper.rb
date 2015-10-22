module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command
        crop_command + super.join(' ').sub(/ -crop \S+/, '').split(' ')
      else
        super
      end
    end

    def crop_command
      target = @attachment.instance

      ratio = target.avatar_geometry(:original).width / target.avatar_geometry(:large).width

      if target.cropped?
        ["-crop", "#{(target.crop_w * ratio).to_i}x#{(target.crop_h * ratio).to_i}+#{(target.crop_x * ratio).to_i}+#{(target.crop_y * ratio).to_i}"]
      end
    end
  end
end