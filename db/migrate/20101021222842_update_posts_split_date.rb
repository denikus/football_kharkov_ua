class UpdatePostsSplitDate < ActiveRecord::Migration
  def self.up
    add_column :posts, :year, :integer, :limit => 4
    add_column :posts, :month, :integer, :limit => 2
    add_column :posts, :day, :integer, :limit => 2
    Post.find(:all).each do |item|
      item.year  = item.created_at.strftime("%Y")
      item.month = item.created_at.strftime("%m")
      item.day   = item.created_at.strftime("%d")
      item.save!
    end
  end

  def self.down
    remove_column :posts, :year
    remove_column :posts, :month
    remove_column :posts, :day
  end
end
