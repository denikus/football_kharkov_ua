# -*- encoding : utf-8 -*-
class CreateMatchLinks < ActiveRecord::Migration
  def self.up
    create_table :match_links do |t|
      t.integer :match_id, :dependent => :destroy
      t.enum :link_type, :limit => ['video', 'audio', 'photo', 'review', 'other'], :default => 'other'
      t.string :link_href, :limit => 255
      t.string :link_text, :limit => 255
    end
  end

  def self.down
    drop_table :match_links
  end
end
