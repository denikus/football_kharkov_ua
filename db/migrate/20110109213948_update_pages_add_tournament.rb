# -*- encoding : utf-8 -*-
class UpdatePagesAddTournament < ActiveRecord::Migration
  def self.up
    rename_column :pages, :permalink, :url
    add_column :pages, :tournament_id, :integer, :references => [:tournaments, :id], :default => nil
  end

  def self.down
    rename_column :pages, :url, :permalink
    remove_column :pages, :tournament_id
  end
end
