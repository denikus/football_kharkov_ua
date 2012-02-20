# -*- encoding : utf-8 -*-
class CreateSubscribers < ActiveRecord::Migration
  def self.up
    create_table :subscribers do |t|
      t.integer :post_id, :on_delete => :cascade
      t.integer :user_id, :on_delete => :cascade
    end
  end

  def self.down
    drop_table :subscribers
  end
end
