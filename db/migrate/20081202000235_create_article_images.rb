# -*- encoding : utf-8 -*-
class CreateArticleImages < ActiveRecord::Migration
  def self.up
    create_table :article_images do |t|
      t.integer :article_id
      t.string :file, :limit => 255
      t.string :title, :limit => 255
    end
  end

  def self.down
    drop_table :article_images
  end
end
