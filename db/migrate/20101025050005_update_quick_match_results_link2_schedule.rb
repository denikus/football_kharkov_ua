# -*- encoding : utf-8 -*-
class UpdateQuickMatchResultsLink2Schedule < ActiveRecord::Migration
  def self.up
    add_column :quick_match_results, :schedule_id, :integer, :references => [:schedules, :id], :name => :fk_quick_match_result_2_season, :on_delete => :no_action
    remove_column :quick_match_results, :hosts
    remove_column :quick_match_results, :guests
    remove_column :quick_match_results, :author_id
    remove_column :quick_match_results, :tournament_id
    remove_column :quick_match_results, :match_on
  end

  def self.down
    add_column :quick_match_results, :hosts, :limit => 255
    add_column :quick_match_results, :guests, :limit => 255
    add_column :quick_match_results, :tournament_id, :integer, :name=>"fk_tournament_quick_match_results", :references=>[:tournaments, :id], :on_delete => :set_null
    add_column :quick_match_results, :author_id, :integer, :name=>"fk_user_quick_match_results", :references=>[:users, :id], :on_delete => :set_null
    add_column :quick_match_results, :match_on, :date
    remove_column :quick_match_results, :schedule_id
  end
end
