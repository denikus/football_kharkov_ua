class UpdateFootballerAddUrl < ActiveRecord::Migration
  def self.up
    add_column :footballers, :url, :string, :limit => 255 
  end

  def self.down
    remove_column :footballers, :url
  end
end
