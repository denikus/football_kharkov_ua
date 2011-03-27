class CreateTourResults < ActiveRecord::Migration
  def self.up
    create_table :tour_results do |t|
      t.integer :season_id, :dependent => :destroy
      t.text :body
    end
  end

  def self.down
    drop_table :tour_results
  end
end
