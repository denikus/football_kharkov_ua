class UpdatePostShowComment < ActiveRecord::Migration
  def self.up
    add_column :posts, :hide_comments, :boolean, :default => false
  end

  def self.down
    remove_column :posts, :hide_comments
  end
end
