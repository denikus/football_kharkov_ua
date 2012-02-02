# -*- encoding : utf-8 -*-
class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.column  :title, :string, :limit=>255
      t.column :body, :text
    end
  end

  def self.down
    drop_table :articles
  end
end
