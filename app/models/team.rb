class Team < ActiveRecord::Base
#  has_and_belongs_to_many :footballers
  has_and_belongs_to_many :leagues
  has_many :footballers, :through => :seasons

  has_many :competitors, :dependent => :destroy
end
