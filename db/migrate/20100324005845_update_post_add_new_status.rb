class UpdatePostAddNewStatus < ActiveRecord::Migration
  def self.up
    change_column :posts, :status, :enum, :limit => ['published', 'hidden', 'updating'], :default => 'published'
  end

  def self.down
    change_column :posts, :status, :enum, :limit => ['published', 'hidden'], :default => 'published'
  end
end
