class UpdateScheduleLink2Tour < ActiveRecord::Migration
  def self.up
    remove_column :schedules, :season_id
    add_column :schedules, :tour_id, :integer, :references => [:tours, :id], :name => "schedule_2_tour"
  end

  def self.down
    remove_column :schedules, :tour_id
    add_column :schedules, :season_id, :integer, :references => [:seasons, :id], :name => "schedule_2_season"
  end
end
