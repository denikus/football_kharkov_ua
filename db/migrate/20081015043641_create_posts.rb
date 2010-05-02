class CreatePosts < ActiveRecord::Migration
  def self.up
    #drop_table :contents
    create_table :posts do |t|
      t.column  :author_id, :integer, :name=>"fk_user_post", :references=>[:users, :id], :on_delete => :cascade
      t.column  :resource_id, :integer, :references=>nil
      t.column  :resource_type, :string, :limit=>255
      t.column  :status, :enum, :limit => ['published', 'hidden'], :default => 'published'
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
    create_table :contents
  end
end
