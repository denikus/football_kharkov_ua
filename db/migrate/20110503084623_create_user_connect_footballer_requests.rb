# -*- encoding : utf-8 -*-
class CreateUserConnectFootballerRequests < ActiveRecord::Migration
  def self.up
    create_table :user_connect_footballer_requests do |t|
      t.integer :user_id
      t.integer :footballer_id
      t.integer :provider_uid
      t.string :provider
      t.text :provider_data
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.boolean :processed, :default => false
      t.datetime :photo_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :user_connect_footballer_requests
  end
end
