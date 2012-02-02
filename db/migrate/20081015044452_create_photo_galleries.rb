# -*- encoding : utf-8 -*-
class CreatePhotoGalleries < ActiveRecord::Migration
  def self.up
    create_table :photo_galleries do |t|
      t.column  :title, :string, :limit=>255
    end
  end

  def self.down
    drop_table :photo_galleries
  end
end
