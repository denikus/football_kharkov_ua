class CreateProfileAvatars < ActiveRecord::Migration
  def self.up
    create_table :profile_avatars do |t|
      t.integer :profile_id, :references => [:profiles, :id], :name => :fk_profiles_profile_avatars, :on_delete => :cascade
      t.string :content_type, :null => false
      t.string :filename, :null => false
      t.integer :size, :null => false
      t.integer :width, :null => true
      t.integer :height, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :profile_avatars
  end
end
