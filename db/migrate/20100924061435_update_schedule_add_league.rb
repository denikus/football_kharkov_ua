# -*- encoding : utf-8 -*-
class UpdateScheduleAddLeague < ActiveRecord::Migration
  def self.up
    add_column :schedules, :league_id, :integer, :references => [:leagues, :id], :name => :fk_schedule_2_league, :on_delete => :no_action
  end

  def self.down
    remove_column :schedules, :league_id
  end
end
