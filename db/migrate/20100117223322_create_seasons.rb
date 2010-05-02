class CreateSeasons < ActiveRecord::Migration
  def self.up
    create_table :seasons do |t|
      t.integer :tournament_id, :null => false, :on_delete => :restrict
      t.string :name, :null => false, :limit => 255
      t.string :url, :null => false, :limit => 255
      t.date :started_on, :default => nil
      t.timestamps
    end
  end

  def self.down
    drop_table :seasons
  end
end
