class CreateMatchMiscEvents < ActiveRecord::Migration
  def self.up
    create_table :match_misc_events do |t|
      t.enum :event_type, :limit => [:time, :moment, :off_game, :misc], :null => false, :default => :misc
    end
  end

  def self.down
    drop_table :match_misc_events
  end
end
