class UpdateUserDeviseFields < ActiveRecord::Migration
  def up
    add_column :users, :unconfirmed_email, :string
    add_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :remember_token
  end

  def down
    remove_column :users, :unconfirmed_email
    add_column :users, :remember_token, :string, :limit => 20
  end
end
