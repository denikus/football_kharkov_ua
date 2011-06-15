class CreateFootballPlayerAppointments < ActiveRecord::Migration
  def self.up
    create_table :football_player_appointments do |t|
      t.integer :id
      t.integer :competitor_id
      t.integer :footballer_id
      t.enum :response, :null => false, :limit => [:not_responded, :accepted, :declined, :tentative], :default => :not_responded
    end
  end

  def self.down
    drop_table :football_player_appointments
  end
end
