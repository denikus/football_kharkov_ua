# -*- encoding : utf-8 -*-
class Footballer < ActiveRecord::Base
  has_attached_file :photo, :styles => {:large => {:geometry => "500x500>"}, :medium=> {:geometry => "200x200>", :processors => [:cropper]}, :thumb => {:geometry => "50x50>", :processors => [:cropper]}, :small_thumb => {:geometry => "35x35", :processors => [:cropper]} },
                    :path => ":rails_root/public/:class/:attachment/:id/:style/:basename.:extension",
                    :url => "/:class/:attachment/:id/:style/:basename.:extension",
                    :default_url => "/:class/:attachment/missing_:style.png"
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  before_save :prepare_data
  before_update :crop_image
  after_update :reprocess_photo, :if => :cropping?
  
  has_many :footballers_teams
  has_one :user_connect_footballer_request
  belongs_to :user

  scope :by_team_step, lambda{ |options|
    joins(:footballers_teams).
    where({:footballers_teams => {:step_id => options[:step_id], :team_id => options[:team_id]}}).
    order('last_name ASC')
  }

  def full_name
    [last_name, first_name, patronymic].join(" ")
  end
  
  alias_method :name, :full_name

  def prepare_data
    self.last_name.strip!
    self.first_name.strip!
    self.patronymic.strip! unless self.patronymic.nil?
    self.url = [self.last_name, self.first_name, self.patronymic].join("-")
  end

  def merge_user(user_id)
    self.user_id = user_id
    save
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(photo.to_file(style))
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
