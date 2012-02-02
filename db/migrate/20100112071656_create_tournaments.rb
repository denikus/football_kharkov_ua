# -*- encoding : utf-8 -*-
class CreateTournaments < ActiveRecord::Migration
  def self.up
    create_table :tournaments do |t|
      t.string :name, :null => false, :limit => 255
      t.string :url, :null => false, :limit => 255
      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments
  end
end
