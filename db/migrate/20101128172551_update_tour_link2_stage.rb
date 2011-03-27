class UpdateTourLink2Stage < ActiveRecord::Migration
  def self.up
    remove_column :tours, :league_id
    add_column :tours, :stage_id, :integer, :references => [:stages, :id], :name => "tour_2_stage"
  end

  def self.down
    add_column :tours, :league_id, :integer, :references => [:leagues, :id], :name => "tour_2_league"
    remove_column :tours, :stage_id
  end
end
