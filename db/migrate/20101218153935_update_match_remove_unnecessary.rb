# -*- encoding : utf-8 -*-
class UpdateMatchRemoveUnnecessary < ActiveRecord::Migration
  def self.up
    remove_column :matches, :referee_id
    remove_column :matches, :match_type
    remove_column :matches, :period_duration
    remove_column :matches, :comment
  end

  def self.down
    add_column :matches, :referee_id, :integer, :null => false, :references => [:referees, :id], :name => :fk_referees_matches, :on_delete => :no_action
    add_column :matches, :match_type, :enum,:limit => [:big, :mini], :null => false, :default => :mini
    add_column :matches, :period_duration, :integer, :limit => 2, :null => false
    add_column :matches, :comment, :text,:null => true
  end
end
