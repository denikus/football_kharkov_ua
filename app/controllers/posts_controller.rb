# -*- encoding : utf-8 -*-

class PostsController < ApplicationController

  def show
    @post = Post.find_by_path(params[:id])

    render "#{Rails.root}/public/404.html", :status => 404, :layout => false if @post.nil?

    @page_title = @post.title

    render "post/show"
  end
end