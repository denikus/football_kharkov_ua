# -*- encoding : utf-8 -*-
class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :admin_id, :references => [:admins, :id], :name => :fk_admins_permissions, :on_delete => :cascade
      t.string :controller, :null => false
      t.string :action, :null => false
    end
    add_index :permissions, :admin_id
  end

  def self.down
    drop_table :permissions
  end
end
