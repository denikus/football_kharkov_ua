class DropSchedulePost < ActiveRecord::Migration
  def self.up
    Comment.delete_all(:post_id => [293, 308, 350, 358])
    Post.delete_all(:resource_type => ['SchedulePost'])
    drop_table :schedule_posts
  end

  def self.down
    create_table :schedule_posts do |t|
      t.text :body
      t.text :generated_body
    end
  end
end
