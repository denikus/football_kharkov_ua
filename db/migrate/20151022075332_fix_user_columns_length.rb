class FixUserColumnsLength < ActiveRecord::Migration
  def change
    change_column :users, :encrypted_password, :string, limit: 255
    change_column :users, :password_salt, :string, limit: 255
    change_column :users, :confirmation_token, :string, limit: 255
    change_column :users, :reset_password_token, :string, limit: 255
  end

end
