# -*- encoding : utf-8 -*-
class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      t.string :full_name, :limit => 64, :null => false
      t.integer :role_flags, :null => false, :default => 1
      #t.authenticatable
      t.string :authentication_token
      #t.rememberable
      t.datetime :remember_created_at
      t.timestamps
    end
  end

  def self.down
    drop_table :admins
  end
end
