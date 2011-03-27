class UpdateAdminsRoleFlagsToSuperAdmin < ActiveRecord::Migration
  def self.up
    rename_column :admins, :role_flags, :super_admin
    change_column :admins, :super_admin, :boolean, :null => false, :default => false
  end

  def self.down
    rename_column :admins, :super_admin, :role_flags
    change_column :admins, :role_flags, :integer, :null => false, :default => 1
  end
end
