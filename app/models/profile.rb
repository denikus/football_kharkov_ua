# -*- encoding : utf-8 -*-
class Profile < ActiveRecord::Base
  belongs_to :user

  has_attached_file :photo, :url => "/system/:attachment/:id/:style/:filename",
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :styles => {:large => {:geometry => "500x500>"},
                                :medium=> {:geometry => "200x200>", :processors => [:cropper]},
                                :thumb => {:geometry => "50x50>", :processors => [:cropper]},
                                :small_thumb => {:geometry => "35x35", :processors => [:cropper]}
                    }
  has_attached_file :avatar, :path => ":rails_root/public/system/:attachment/:id/:style/:filename", :styles => { :small => {:geometry => "50x50>", :processors => [:cropper]}, :very_small => {:geometry => "35x35", :processors => [:cropper]} }

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_photo, :if => :cropping?

#  has_one :profile_avatar

  GENDER_OPTIONS = [[:unknown, 'Еще не определился'], [:male, 'Мужик'], [:female, 'Дама']]
  USER_TYPE_OPTIONS = [[:fan, 'Болельщик'], [:footballer, 'Футболист']]
  ROLE_OPTIONS = [[:unknown, 'Еще не определился'], [:ball_boy, 'Подаю мячи'], [:goalkeeper, 'Вратарь'], [:fullback, 'Защитник'], [:halfback, 'Полузащитник'], [:forward, 'Форвард'], [:coach, 'Тренер']]

  before_update :crop_image

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(photo.to_file(style)) unless photo.to_file(style).blank?
  end

  def crop_image
    if cropping?
      self.crop_x_left    = crop_x
      self.crop_y_top     = crop_y
      self.crop_width     = crop_w
      self.crop_height    = crop_h
    end
  end

  private

  def reprocess_photo
    photo.reprocess!
  end

end
