class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.column :title, :string, :limit=>255, :null=>false
      t.column :body, :text, :null=>true
      t.column :type, :string, :limit=>255
      t.column :author_id, :integer, :references=>:users
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
  end

  def self.down
    drop_table :contents
  end
end
