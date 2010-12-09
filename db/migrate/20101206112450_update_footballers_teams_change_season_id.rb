class UpdateFootballersTeamsChangeSeasonId < ActiveRecord::Migration
  def self.up
    rename_column :footballers_teams, :season_id, :step_id
    change_column :footballers_teams, :step_id, :integer, :references => ['steps', 'id'], :name => 'fk_footballers_teams_steps', :on_delete => :cascade
  end

  def self.down
    rename_column :footballers_teams, :step_id, :season_id
    change_column :footballers_teams, :season_id, :integer, :references => ['sesons', 'id'], :name => 'fk_footballers_teams_seasons', :on_delete => :cascade
  end
end
