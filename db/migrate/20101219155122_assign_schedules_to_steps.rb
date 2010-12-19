class AssignSchedulesToSteps < ActiveRecord::Migration
  def self.up
    remove_column :schedules, :league_id
    remove_column :schedules, :tour_id
    add_column :schedules, :league_id, :integer, :references => %w{steps id}, :name => 'fk_schedules_step_leagues', :on_delete => :cascade
    add_column :schedules, :tour_id, :integer, :references => %w{steps id}, :name => 'fk_schedules_step_tours', :on_delete => :cascade
  end

  def self.down
    remove_column :schedules, :league_id
    remove_column :schedules, :tour_id
    add_column :schedules, :league_id, :integer, :references => %w{leagues id}, :name => 'fk_schedules_leagues', :on_delete => :cascade
    add_column :schedules, :tour_id, :integer, :references => %w{tours id}, :name => 'fk_schedules_tours', :on_delete => :cascade
  end
end
