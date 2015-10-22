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
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_photo, :if => :cropped?

#  has_one :profile_avatar

  GENDER_OPTIONS = [[:unknown, 'Еще не определился'], [:male, 'Мужик'], [:female, 'Дама']]
  USER_TYPE_OPTIONS = [[:fan, 'Болельщик'], [:footballer, 'Футболист']]
  ROLE_OPTIONS = [[:unknown, 'Еще не определился'], [:ball_boy, 'Подаю мячи'], [:goalkeeper, 'Вратарь'], [:fullback, 'Защитник'], [:halfback, 'Полузащитник'], [:forward, 'Форвард'], [:coach, 'Тренер']]

  # before_update :crop_image

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    # ava_path = photo.photo_geometry(style).path unless photo.nil?#if !photo.nil? && !photo.queued_for_write[style].nil?
    # avatar_geometry(style).width
    # @geometry[style] ||= Paperclip::Geometry.from_file(ava_path) #if !photo.nil? && !photo.queued_for_write[style].nil?
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style)) if !photo.nil? #if !photo.nil? && !photo.queued_for_write[style].nil?

  end

  def cropped?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
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
    # photo.reprocess!
    photo.assign(avatar)
    photo.save
  end

end
