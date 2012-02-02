# -*- encoding : utf-8 -*-
class CreateTeamsFootballers < ActiveRecord::Migration
  def self.up
    create_table :footballers_teams, :id => false do |t|
      t.integer :footballer_id
      t.integer :team_id
    end
    add_index :footballers_teams, :footballer_id
    add_index :footballers_teams, :team_id
  end

  def self.down
    drop_table :footballers_teams
  end
end
