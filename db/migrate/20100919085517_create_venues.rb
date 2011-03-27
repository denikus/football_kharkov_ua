class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.string :name, :limit => 255
      t.string :short_name, :limit => 255
      t.string :url, :limit => 255
      t.string :icon, :limit => 255
      t.timestamps
    end
  end

  def self.down
    drop_table :venues
  end
end
