class CreateMatchEvents < ActiveRecord::Migration
  def self.up
    create_table :match_events do |t|
      t.integer :match_id, :references => [:matches, :id], :name => :fk_matches_match_events, :on_delete => :cascade
      #t.references :event, :polymorphic => true
      t.integer :event_id, :references => nil
      t.string :event_type
      t.integer :minute, :length => 3
      t.text :message
    end
    add_index :match_events, :match_id
  end

  def self.down
    drop_table :match_events
  end
end
