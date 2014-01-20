# -*- encoding : utf-8 -*-
class CommentController < ApplicationController

  protect_from_forgery :except => [:create]

  def create
    #create root comment if it doesn't exists yet
    @comment = Comment.new({:body => ApplicationController.helpers.white_list(params[:comment][:body]), :author_id => current_user[:id], :post_id => params[:comment][:post_id]})
    if @comment.valid?
      post = Post.find(params[:comment][:post_id])
      if post.comments.empty?
        root_comment = Comment.new({:body => 'root', :author_id => post.author_id, :post_id => params[:comment][:post_id]})
        root_comment.save
      end
      if @comment.save
        #find parent node for new comment
        if params[:comment][:parent_id].nil?
          parent_comment = Post.find(params[:comment][:post_id]).comments.find_by_parent_id(nil)
        else
          parent_comment = Post.find(params[:comment][:post_id]).comments.find(params[:comment][:parent_id])
        end
        
        #make comment as child of parent
        @comment.move_to_child_of parent_comment

        if !@comment.siblings.empty?
          latest_sibling = @comment.siblings[@comment.siblings.length-1]
          if !latest_sibling.children.empty?
            after_id = latest_sibling.children[latest_sibling.children.length-1].id
          else   
            after_id = @comment.siblings[@comment.siblings.length-1].id
          end
        else   
          after_id = @comment.parent_id
        end
        
        author = User.find(@comment.author_id)
        
        result_data = {:success => true, :id => @comment.id, :level => @comment.level, 
               :parent_id => @comment.parent_id, :body => @comment.body.gsub("\n", "<br />\n"), 
               :post_id => @comment.post_id, :after => after_id,
               :author_login => author.username, :comment_date => Russian::strftime(@comment.created_at, "%B %d, %Y; %H:%M")
              }
      end
    else 
        errors = []
        if @comment.errors.invalid?(:post_id)
          errors << l("Comment should be attached to the post")
        end
        if @comment.errors.invalid?(:body)
          errors << l("Comment shouldn't be empty")
        end
        if @comment.errors.invalid?(:author_id)
          errors << l("You should be logged in to post comment")
        end
        
        result_data = {:success => false, :errors => errors}
    end

    render :text => result_data.to_json, :layout => false
  end
end
