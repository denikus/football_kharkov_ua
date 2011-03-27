class CreateMatchEventTypes < ActiveRecord::Migration
  def self.up
    create_table :match_event_types do |t|
      t.string :symbol
      t.string :template
    end
  end

  def self.down
    drop_table :match_event_types
  end
end
