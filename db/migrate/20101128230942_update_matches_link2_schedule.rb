class UpdateMatchesLink2Schedule < ActiveRecord::Migration
  def self.up
    remove_column :matches, :tour_id
    add_column :matches, :schedule_id, :integer, :references => [:schedules, :id], :name => "match_2_schedule"
  end

  def self.down
    remove_column :matches, :schedule_id
    add_column :matches, :tour_id, :integer, :references => [:tours, :id], :name => "match_2_tour"
  end
end
