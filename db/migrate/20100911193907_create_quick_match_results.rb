# -*- encoding : utf-8 -*-
class CreateQuickMatchResults < ActiveRecord::Migration
  def self.up
    create_table :quick_match_results do |t|
      t.string :hosts, :limit => 255
      t.string :guests, :limit => 255
      t.integer :hosts_score, :limit => 99
      t.integer :guests_score, :limit => 99
      t.integer :author_id, :name=>"fk_user_quick_match_results", :references=>[:users, :id], :on_delete => :set_null
      t.integer :tournament_id, :name=>"fk_tournament_quick_match_results", :references=>[:tournaments, :id], :on_delete => :set_null
      t.date :match_on
      t.timestamps
    end
  end

  def self.down
    drop_table :quick_match_results
  end
end
