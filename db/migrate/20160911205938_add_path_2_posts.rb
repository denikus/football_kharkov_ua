class AddPath2Posts < ActiveRecord::Migration
  def up
    add_column :posts, :path, :string, index: true
  end

  def down
    remove_column :posts, :path
  end
end
