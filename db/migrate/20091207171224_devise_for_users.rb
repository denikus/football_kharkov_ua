# -*- encoding : utf-8 -*-
class DeviseForUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :hashed_password
    remove_column :users, :last_login_at
    
    change_column :users, :email, :string, :limit => 100, :null => false
    
    add_column :users, :encrypted_password, :string, :limit => 40, :null => false
    add_column :users, :password_salt, :string, :limit => 20, :null => false
    add_column :users, :confirmation_token, :string, :limit => 20
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :reset_password_token, :string, :limit => 20
    add_column :users, :remember_token, :string, :limit => 20
    add_column :users, :remember_created_at, :datetime
    add_column :users, :sign_in_count, :integer
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string

=begin
    User.find(:all).each do |user|
      
    end
=end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
