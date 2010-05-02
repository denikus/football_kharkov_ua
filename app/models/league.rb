class League < ActiveRecord::Base
  belongs_to :stage
  has_many :tours
  has_and_belongs_to_many :teams
end
