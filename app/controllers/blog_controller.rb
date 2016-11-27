# -*- encoding : utf-8 -*-
class BlogController < ApplicationController

  def index
    params[:page] ||= 1
    @posts = Post.includes(:tournament).order('created_at DESC').page(params[:page]).per_page(10)
  end
 
end
