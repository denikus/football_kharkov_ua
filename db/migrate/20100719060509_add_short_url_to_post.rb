class AddShortUrlToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :short_url, :string, :limit => 255, :null => true
  end

  def self.down
    remove_column :posts, :short_url
  end
end
