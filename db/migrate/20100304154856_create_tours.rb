class CreateTours < ActiveRecord::Migration
  def self.up
    create_table :tours do |t|
      t.integer :league_id, :null => false, :references => [:leagues, :id], :name => :fk_leagues_tours, :on_delete => :cascade
      t.string :name, :limit => 255, :null => false
    end
    add_index :tours, :league_id
  end

  def self.down
    drop_table :tours
  end
end
