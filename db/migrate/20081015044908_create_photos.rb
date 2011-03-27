class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.column :photo_gallery_id, :integer, :on_delete => :cascade
      t.column :title, :string, :limit => 255
      t.column :filename, :string, :limit => 255
    end
  end

  def self.down
    drop_table :photos
  end
end
