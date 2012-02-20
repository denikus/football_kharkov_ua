# -*- encoding : utf-8 -*-
class UpdateSchedulesAddScores < ActiveRecord::Migration
  def self.up
    add_column :schedules, :host_scores, :integer, :references => nil, :null => true 
    add_column :schedules, :guest_scores, :integer, :references => nil, :null => true 
  end

  def self.down
    remove_column :schedules, :host_scores
    remove_column :schedules, :guest_scores
  end
end
