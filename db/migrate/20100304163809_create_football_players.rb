class CreateFootballPlayers < ActiveRecord::Migration
  def self.up
    create_table :football_players do |t|
      t.integer :competitor_id, :null => false, :references => [:competitors, :id], :name => :fk_competitors_football_players, :on_delete => :cascade
      t.integer :footballer_id, :null => false, :references => [:footballers, :id], :name => :fk_footballers_football_players, :on_delete => :no_action
      t.integer :number, :limit => 2, :null => false
    end
    add_index :football_players, :competitor_id
    add_index :football_players, :footballer_id
  end

  def self.down
    drop_table :football_players
  end
end
