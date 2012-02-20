# -*- encoding : utf-8 -*-
class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    add_index :comments, :author_id
    add_index :stats, [:statable_id, :statable_type]
    add_index :posts, [:resource_id, :resource_type]
    add_index :posts, :author_id
    add_index :schedules, :guest_team_id
    add_index :schedules, :season_id
    add_index :schedules, :venue_id
    add_index :schedules, :league_id
    add_index :schedules, :host_team_id
    add_index :footballers_teams, :season_id
    add_index :posts, [:url_year, :url_month, :url_day, :url]
  end

  def self.down
    remove_index :comments, :author_id
    remove_index :stats, :column => [:statable_id, :statable_type]
    remove_index :posts, :column => [:resource_id, :resource_type]
    remove_index :posts, :author_id
    remove_index :schedules, :guest_team_id
    remove_index :schedules, :season_id
    remove_index :schedules, :venue_id
    remove_index :schedules, :league_id
    remove_index :schedules, :host_team_id
    remove_index :footballers_teams, :season_id
    remove_index :posts, [:url_year, :url_month, :url_day, :url]
  end
end
