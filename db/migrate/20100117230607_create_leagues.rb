class CreateLeagues < ActiveRecord::Migration
  def self.up
    create_table :leagues do |t|
      t.integer :stage_id, :null => false, :on_delete => :restrict
      t.string :name, :null => false, :limit => 255
      t.string :url, :null => false, :limit => 255
      t.timestamps
    end
  end

  def self.down
    drop_table :leagues
  end
end
