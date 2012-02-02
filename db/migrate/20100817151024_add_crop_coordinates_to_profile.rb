# -*- encoding : utf-8 -*-
class AddCropCoordinatesToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :crop_x_left, :integer
    add_column :profiles, :crop_y_top, :integer
    add_column :profiles, :crop_width, :integer
    add_column :profiles, :crop_height, :integer
  end

  def self.down
    remove_column :profiles, :crop_x_left
    remove_column :profiles, :crop_y_top
    remove_column :profiles, :crop_width
    remove_column :profiles, :crop_height
  end
end
