# -*- encoding : utf-8 -*-
class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer   :user_id, :on_delete => :cascade
      t.enum      :gender, :limit => ['unknown', 'male', 'female'], :default => 'unknown'
      t.enum      :user_type, :limit => ['fan', 'footballer'], :default => 'fan'
      t.enum      :role, :limit => ['unknown', 'ball_boy', 'goalkeeper', 'fullback', 'halfback', 'forward', 'coach'], :default => 'unknown'
      t.string    :first_name, :limit => 255
      t.string    :last_name, :limit => 255
      t.date      :birthday, :null => true
      t.string    :avatar_file_name, :limit => 255
      t.string    :avatar_content_type, :limit => 255
      t.integer   :avatar_file_size
      t.datetime  :avatar_updated_at
      t.timestamps
    end
    User.find(:all).each do |user|
      user.profile = Profile.new()
      user.save
    end
  end

  def self.down
    drop_table :profiles
  end
end
