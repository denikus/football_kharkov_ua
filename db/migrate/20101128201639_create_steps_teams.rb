# -*- encoding : utf-8 -*-
class CreateStepsTeams < ActiveRecord::Migration
  def self.up
    create_table :steps_teams, :id => false do |t|
      t.integer :step_id, :references => [:steps, :id], :name => 'fk_steps_teams_steps', :on_delete => :cascade
      t.integer :team_id, :references => [:teams, :id], :name => 'fk_steps_teams_teams', :on_delete => :cascade
    end
  end

  def self.down
    drop_table :steps_teams
  end
end
