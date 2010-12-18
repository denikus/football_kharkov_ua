class CreateMatchesReferees < ActiveRecord::Migration
  def self.up
    create_table :matches_referees, :id => false do |t|
      t.integer :match_id
      t.integer :referee_id
    end
    add_index :matches_referees, :match_id
    add_index :matches_referees, :referee_id
  end

  def self.down
#    drop_table :matches_referees
  end
end
