class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.integer :id
      t.integer :team_id, :references => [:teams, :id]
      t.integer :owner_id, :references => [:users, :id]
      t.integer :season_id
      t.timestamps
    end
  end
end
