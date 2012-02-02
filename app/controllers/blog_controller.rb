# -*- encoding : utf-8 -*-
class BlogController < ApplicationController
#  include ActionController::UrlWriter
#  default_url_options[:host] = 'localhost:3000'
#  layout 'application'
  def index

    puts "!!!!!!!!!!!!!!!!!!!!!"
    ap request.subdomain
    puts "!!!!!!!!!!!!!!!!!!!!!"
    params[:page] = 1 if !params[:page]
    @posts = Post.paginate(:page => params[:page], :per_page => 10, :include => :tournament, :order => 'created_at DESC')
  end
 
end
