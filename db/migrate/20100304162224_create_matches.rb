# -*- encoding : utf-8 -*-
class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :tour_id, :null => false, :references => [:tours, :id], :name => :fk_tours_matches, :on_delete => :cascade
      t.integer :referee_id, :null => false, :references => [:referees, :id], :name => :fk_referees_matches, :on_delete => :no_action
      t.enum :match_type, :limit => [:big, :mini], :null => false, :default => :mini
      t.datetime :played_at, :null => false
      t.integer :period_duration, :limit => 2, :null => false
      t.text :comment, :null => true
      t.timestamps
    end
    add_index :matches, :tour_id
    add_index :matches, :referee_id
  end

  def self.down
    drop_table :matches
  end
end
