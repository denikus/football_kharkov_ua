class PostAddUrl < ActiveRecord::Migration
  def self.up
    remove_column :articles, :title
    remove_column :photo_galleries, :title
    add_column :posts, :url, :string, :limit => 255, :null => true
    add_column :posts, :title, :string, :limit => 255, :null => false
  end

  def self.down
    remove_column :posts, :url
    remove_column :posts, :title
    add_column :articles, :title, :string, :limit => 255
    add_column :photo_galleries, :title, :string, :limit => 255
  end
end
