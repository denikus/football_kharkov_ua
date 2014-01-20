# -*- encoding : utf-8 -*-
require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  pending "adding article and post" do

    article = Factory.build(:article)
    post = Factory.build(:post)
    post.resource = article
    post.resource_id = article.id

    assert post.valid?

    assert post.save!
  end

  test "adding tags to post(article)" do
    tags = "tag1, tag2, tag3"
    tags_array =["tag1", "tag2", "tag3"] 
    
    article = Factory.build(:article)
    post = Factory.build(:post, :tag_list => tags)
    post.resource = article
    post.resource_id = article.id

=begin
    tags = []
    3.times do |index|
      tags << "tag#{index}"
    end
=end


#    post.tag_list = tags

    assert post.save!
    post_id = post.id
    load_post = Post.find(post_id)
    
    #check if all tags saved
    assert_equal(tags_array, load_post.tag_list)
  end
end
