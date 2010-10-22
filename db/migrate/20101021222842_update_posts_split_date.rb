class UpdatePostsSplitDate < ActiveRecord::Migration
  def self.up
    add_column :posts, :url_year, :integer, :limit => 4
    add_column :posts, :url_month, :integer, :limit => 2
    add_column :posts, :url_day, :integer, :limit => 2
    Post.find(:all).each do |item|
      item.url_year  = item.created_at.strftime("%Y")
      item.url_month = item.created_at.strftime("%m")
      item.url_day   = item.created_at.strftime("%d")
      item.save!
    end
  end

  def self.down
    remove_column :posts, :url_year
    remove_column :posts, :url_month
    remove_column :posts, :url_day
  end
end
