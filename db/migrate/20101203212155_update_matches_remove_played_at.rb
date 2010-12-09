class UpdateMatchesRemovePlayedAt < ActiveRecord::Migration
  def self.up
    remove_column :matches, :played_at
    change_column :matches, :referee_id, :integer, :null => true
    change_column :matches, :period_duration, :integer, :limit => 2, :null => false, :default => 25

  end

  def self.down
    add_column :matches, :played_at, :datetime, :null => false
    change_column :matches, :referee_id, :integer, :null => false
    change_column :matches, :period_duration, :integer, :limit => 2, :null => false
  end
end
