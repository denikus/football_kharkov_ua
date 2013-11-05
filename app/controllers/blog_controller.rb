# -*- encoding : utf-8 -*-
class BlogController < ApplicationController

  def index
    params[:page] ||= 1
    @posts = Post.paginate(:page => params[:page], :per_page => 10, :include => :tournament, :order => 'created_at DESC')
  end
 
end
