class TourResultController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
#  before_filter :check_permissions, :except => [:show, :new, :create]

  def new
    @tournaments = Tournament.find(:all, :order => "name ASC")
  end

  def create
    
  end

  def matches_block
    @leagues = League.find(:all, :conditions => {:stage_id => params[:stage_id]})
    render :layout => false
  end

=begin
private

  def check_permissions
    article = Article.find(params[:id])
    post = article.post
    if post.author_id!=current_user[:id] && current_user[:id] != 1
      flash[:error] = "Недостаточно прав для данного действия!"
      redirect_to post_url({:year => post.created_at.strftime('%Y'), :month => post.created_at.strftime('%m'), :day => post.created_at.strftime('%d'), :url => !post.url.nil? ? post.url : ''})
    end
  end

=end
  
end
