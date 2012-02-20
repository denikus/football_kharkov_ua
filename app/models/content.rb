# -*- encoding : utf-8 -*-
class Content < ActiveRecord::Base
  validates_presence_of :title
end
