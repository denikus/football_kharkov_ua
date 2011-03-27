class CreateCompetitors < ActiveRecord::Migration
  def self.up
    create_table :competitors do |t|
      t.integer :match_id, :null => false, :references => [:matches, :id], :name => :fk_matches_competitors, :on_delete => :cascade
      t.enum :side, :null => false, :limit => [:hosts, :guests], :default => :hosts
      t.integer :team_id, :null => false, :references => [:teams, :id], :name => :fk_teams_competitors, :on_delete => :no_action
      t.integer :score, :limit => 2, :null => false, :default => 0
    end
    add_index :competitors, :match_id
    add_index :competitors, :team_id
  end

  def self.down
    drop_table :competitors
  end
end
