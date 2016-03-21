class AddCommentsSouce2Comments < ActiveRecord::Migration
  def up
    add_column :comments, :source, :text
    Comment.find_each do |comment|
      comment.source = comment.body
      comment.save
    end
  end

  def down
    remove_column :comments, :source
  end
end
