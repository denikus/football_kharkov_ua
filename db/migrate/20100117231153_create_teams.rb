# -*- encoding : utf-8 -*-
class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name, :null => false, :limit => 255
      t.string :url, :null => false, :limit => 255
      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
