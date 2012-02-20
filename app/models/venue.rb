# -*- encoding : utf-8 -*-
class Venue < ActiveRecord::Base

  def to_param
    url
  end

  def self.from_param(param)
    find_by_url!(param)
  end
end
