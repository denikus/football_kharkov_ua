# -*- encoding : utf-8 -*-
class Comment < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :user, :foreign_key => :author_id
  belongs_to :post
  acts_as_nested_set

  scope :tournament, lambda{ |tournament_subdomain|
    unless (tournament_subdomain.nil? || tournament_subdomain.empty?)
      {:joins => "INNER JOIN posts AS posts2 ON (comments.post_id=posts2.id)  INNER JOIN tournaments ON (posts2.tournament_id = tournaments.id) ", :conditions => ["tournaments.url = ?", tournament_subdomain]}
    end
  }

  validates_presence_of :body
  validates_presence_of :author_id
  validates_presence_of :post_id

  before_create :prepare_data

  def prepare_data
    self.source = self.body

    links = URI.extract(self.body)

    content = self.body

    unless links.empty?
    #   content = self.body)
    # else
      links.each do |link|
        begin
          page = MetaInspector.new(link, html_content_only: false)
          if page.content_type.start_with?('image')
            img_src = link
          else
            img_src = page.images.best
          end
          content.gsub!(link, "#{ActionController::Base.helpers.link_to image_tag(img_src, style: 'max-width: 400px;max-height: 200px;'), link, target: '_blank'} <br/>")
        rescue Exception => e
          content.gsub!(link, " #{ActionController::Base.helpers.link_to link, link, target: '_blank'} <br/>")
        end
      end
    end

    self.body = content
  end
end
