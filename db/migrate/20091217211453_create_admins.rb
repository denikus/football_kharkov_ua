class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      t.string :full_name, :limit => 64, :null => false
      t.integer :role_flags, :null => false, :default => 1
      t.authenticatable
      t.rememberable
      t.timestamps
    end
  end

  def self.down
    drop_table :admins
  end
end
