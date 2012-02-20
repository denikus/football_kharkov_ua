# -*- encoding : utf-8 -*-
class CreateSchedulePosts < ActiveRecord::Migration
  def self.up
    create_table :schedule_posts do |t|
      t.text :body
      t.text :generated_body
    end
  end

  def self.down
    drop_table :schedule_posts
  end
end
