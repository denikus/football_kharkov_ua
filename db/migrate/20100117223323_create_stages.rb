# -*- encoding : utf-8 -*-
class CreateStages < ActiveRecord::Migration
  def self.up
    create_table :stages do |t|
      t.integer :season_id, :null => false, :on_delete => :restrict
      t.integer :number
      t.timestamps
    end
  end

  def self.down
    drop_table :stages
  end
end
