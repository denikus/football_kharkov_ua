# -*- encoding : utf-8 -*-
class AddShortName2Tournament < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :short_name, :string, :limit => 255
  end

  def self.down
    remove_column :tournaments, :short_name
  end
end
