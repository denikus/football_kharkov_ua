class Footballer < ActiveRecord::Base
  has_attached_file :photo, :styles => {:large => {:geometry => "500x500>"}, :medium=> {:geometry => "200x200>", :processors => [:cropper]}, :thumb => {:geometry => "50x50>", :processors => [:cropper]}, :small_thumb => {:geometry => "35x35", :processors => [:cropper]} },
                    :path => ":rails_root/public/:class/:attachment/:id/:style_:basename.:extension",
                    :url => "/:class/:attachment/:id/:style_:basename.:extension",
                    :default_url => "/:class/:attachment/missing_:style.png"
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_photo, :if => :cropping?
  
  has_many :footballers_teams

  has_one :user_connect_footballer_request
  belongs_to :user
  #named_scope :by_team_season, lambda{ |options|
  #    {:joins => "INNER JOIN footballers_teams ON (footballers_teams.footballer_id=footballers.id)",
  #     :conditions => ["footballers_teams.season_id = ? AND footballers_teams.team_id = ?", options[:season_id], options[:team_id]],
  #     :order => "footballers.last_name ASC"}
  #}
  scope :by_team_step, lambda{ |options| {
    :joins => :footballers_teams,
    :conditions => {:footballers_teams => {:step_id => options[:step_id], :team_id => options[:team_id]}},
    :order => 'last_name ASC'
  } }

  before_save :prepare_data
  before_update :crop_image
  
  def full_name
    [last_name, first_name, patronymic].join(" ")
  end
  
  alias_method :name, :full_name

  def get_teams_seasons
    Footballer.find(:all,
        :select => "tournaments.name AS tournament_name, steps.name AS season_name, teams.name AS team_name, teams.url AS team_address",
        :joins => "INNER JOIN footballers_teams ON (footballers.id = footballers_teams.footballer_id) " +
                  "INNER JOIN teams ON (footballers_teams.team_id = teams.id) " +
                  "INNER JOIN steps ON (footballers_teams.step_id = steps.id AND steps.type = 'StepSeason') " +
                  "INNER JOIN tournaments ON (steps.tournament_id = tournaments.id)",
        :conditions => ["footballers_teams.footballer_id = ?", self.id]
       )


#    Tournament.find(:all,
#                    :select => "tournaments.name AS tournament_name, seasons.name AS season_name, teams.name AS team_name, teams.url AS team_address",
#                    :joins => "INNER JOIN seasons ON (seasons.tournament_id = tournaments.id) " +
#                              "INNER JOIN footballers_teams ON (footballers_teams.season_id = seasons.id) " +
#                              "INNER JOIN teams ON (footballers_teams.team_id = teams.id) ",
#                    :conditions => [" footballers_teams.footballer_id = ? ", self.id]
#            )
  end

  def prepare_data
    self.last_name.strip!
    self.first_name.strip!
    unless self.patronymic.nil?
      self.patronymic.strip!
    end  
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
