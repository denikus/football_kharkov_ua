class CreateMatchPlayerEvents < ActiveRecord::Migration
  def self.up
    create_table :match_player_events do |t|
      t.enum :event_type, :limit => [:score, :card, :injury], :null => false
      t.integer :football_player_id, :references => [:football_players, :id], :name => :fk_football_players_match_player_events, :on_delete => :no_action
    end
    add_index :match_player_events, :football_player_id
  end

  def self.down
    drop_table :match_player_events
  end
end
