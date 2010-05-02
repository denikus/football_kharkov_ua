class Competitor < ActiveRecord::Base
  belongs_to :match
  belongs_to :team
  has_many :football_players
  
  SIDES = [:hosts, :guests].freeze
end
