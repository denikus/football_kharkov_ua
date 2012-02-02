# -*- encoding : utf-8 -*-
class CreateMatchTeamEvents < ActiveRecord::Migration
  def self.up
    create_table :match_team_events do |t|
      t.integer :competitor_id, :references => [:competitors, :id], :name => :fk_competitors_match_team_events, :on_delete => :no_action
    end
  end

  def self.down
    drop_table :match_team_events
  end
end
