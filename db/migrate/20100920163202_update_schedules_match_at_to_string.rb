class UpdateSchedulesMatchAtToString < ActiveRecord::Migration
  def self.up
    change_column :schedules, :match_at, :string, :limit => 5
  end

  def self.down
    change_column :schedules, :match_at, :time
  end
end
