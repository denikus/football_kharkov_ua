# -*- encoding : utf-8 -*-
class CreateSeasonsTeams < ActiveRecord::Migration
  def self.up
    create_table :seasons_teams, :id => false do |t|
      t.integer :season_id
      t.integer :team_id
    end
    add_index :seasons_teams, :season_id
    add_index :seasons_teams, :team_id
  end

  def self.down
    drop_table :seasons_teams
  end
end
