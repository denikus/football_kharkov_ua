# -*- encoding : utf-8 -*-
class LinkTournamentWithPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :tournament_id, :integer, :references => [:tournaments, :id], :name => :fk_tournaments_2_posts, :on_delete => :set_null
  end

  def self.down
    remove_column :posts, :tournament_id
  end
end
