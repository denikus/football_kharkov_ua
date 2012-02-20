# -*- encoding : utf-8 -*-
class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      #fields for nested set
      t.column "parent_id", :integer, :references => nil
      t.column "lft", :integer, :null => false
      t.column "rgt", :integer, :null => false
      #fields for comments
      t.column "post_id", :integer
      t.column "author_id", :integer, :name=>"fk_user_comment", :references=>[:users, :id], :on_delete => :cascade
      t.column "body", :text
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
