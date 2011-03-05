class Comment < ActiveRecord::Base
  belongs_to :user, :foreign_key => :author_id
  belongs_to :post
  acts_as_nested_set

  named_scope :tournament, lambda{ |tournament_subdomain|
    unless (tournament_subdomain.nil? || tournament_subdomain.empty?)
      {:joins => "INNER JOIN posts AS posts2 ON (comments.post_id=posts2.id)  INNER JOIN tournaments ON (posts2.tournament_id = tournaments.id) ", :conditions => ["tournaments.url = ?", tournament_subdomain]}
    end
  }

  validates_presence_of :body
  validates_presence_of :author_id
  validates_presence_of :post_id
end
