class UpdateFootballer2TeamAddSeason < ActiveRecord::Migration
  def self.up
    add_column :footballers_teams, :season_id, :integer, :references => [:seasons, :id], :on_delete => :no_action
  end

  def self.down
    remove_column :footballers_teams, :season_id
  end
end
