# -*- encoding : utf-8 -*-
class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.integer :season_id, :references => [:seasons, :id], :name => :fk_schedule_2_season, :on_delete => :no_action
      t.integer :venue_id, :references => [:venues, :id], :name => :fk_schedule_2_venue, :on_delete => :no_action
      t.date :match_on
      t.time :match_at
      t.integer :host_team_id, :references => [:teams, :id], :name => :fk_schedule_2_host_team, :on_delete => :no_action 
      t.integer :guest_team_id, :references => [:teams, :id], :name => :fk_schedule_2_guest_team, :on_delete => :no_action
      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
