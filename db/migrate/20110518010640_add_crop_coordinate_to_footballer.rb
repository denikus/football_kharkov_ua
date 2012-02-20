# -*- encoding : utf-8 -*-
class AddCropCoordinateToFootballer < ActiveRecord::Migration
  def self.up
    add_column :footballers, :crop_x_left, :integer
    add_column :footballers, :crop_y_top, :integer
    add_column :footballers, :crop_width, :integer
    add_column :footballers, :crop_height, :integer
  end

  def self.down
    remove_column :footballers, :crop_x_left
    remove_column :footballers, :crop_y_top
    remove_column :footballers, :crop_width
    remove_column :footballers, :crop_height
  end
end
