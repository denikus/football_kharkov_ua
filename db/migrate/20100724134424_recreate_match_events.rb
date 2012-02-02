# -*- encoding : utf-8 -*-
class RecreateMatchEvents < ActiveRecord::Migration
  def self.up
    drop_table :match_misc_events
    drop_table :match_team_events
    drop_table :match_player_events
    drop_table :match_events
    
    create_table :match_events do |t|
      t.integer :match_id, :references => [:matches, :id], :name => :fk_matches_match_events, :on_delete => :cascade
      t.integer :match_event_type_id, :references => [:match_event_types, :id], :name => :fk_match_event_types_match_events, :on_delete => :cascade
      t.integer :minute, :length => 3
      t.string :message
    end
    add_index :match_events, :match_id
    add_index :match_events, :match_event_type_id
  end

  def self.down
    drop_table :match_events
    
    create_table :match_events do |t|
      t.integer :match_id, :references => [:matches, :id], :name => :fk_matches_match_events, :on_delete => :cascade
      #t.references :event, :polymorphic => true
      t.integer :event_id, :references => nil
      t.string :event_type
      t.integer :minute, :length => 3
      t.text :message
    end
    add_index :match_events, :match_id
    
    create_table :match_player_events do |t|
      t.enum :event_type, :limit => [:score, :card, :injury], :null => false
      t.integer :football_player_id, :references => [:football_players, :id], :name => :fk_football_players_match_player_events, :on_delete => :no_action
    end
    add_index :match_player_events, :football_player_id
    
    create_table :match_team_events do |t|
      t.integer :competitor_id, :references => [:competitors, :id], :name => :fk_competitors_match_team_events, :on_delete => :no_action
    end
    
    create_table :match_misc_events do |t|
      t.enum :event_type, :limit => [:time, :moment, :off_game, :misc], :null => false, :default => :misc
    end
  end
end
