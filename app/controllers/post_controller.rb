# -*- encoding : utf-8 -*-
class PostController < ApplicationController
#  before_filter :authorize, :except => [:show, :index]
  before_filter :authenticate_user!, :except => [:show, :index]
  
  def index
    params[:page] = 1 if !params[:page] 
    @posts = Post.paginate :page => params[:page], :per_page => 5, :order => 'created_at DESC'
  end

  def new
    @post = Post.new
    @page_title = 'Новая запись'
    
    respond_to do |format|
      format.html # _new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def create
    @post = Post.new(params[:post])
    @post[:author_id] = session[:user]
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Запись успешно сохранена!'
        format.html { redirect_to(:action => 'show', :id => @post.id) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @post = Post.find(params[:id])
    @page_title = 'Редактирование записи'
    
    respond_to do |format|
      format.html # _new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def update
    @post = Post.find(params[:id])
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Запись успешно сохранена!'
        format.html { redirect_to(:action => 'show', :id => @post.id) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
  end
  
  def show
    @post = Post.where(["url_year = :year AND url_month = :month AND url_day = :day AND url = :url ", params]).first
    if @post.nil?
      render "#{Rails.root}/public/404.html", :status => 404, :layout => false
      return
    end

    redirect_to controller: :posts, action: :show, id: @post.path, status: 301

    @page_title = @post.title
    #
    #if !@post.tournament.nil? && request.subdomain.nil?
    #  redirect_params = {:subdomain => @post.tournament.url }
    #  redirect_params.merge!(params)
    #  redirect_params.delete_if {|key,value| !["year", "month", "day", "url", :host].include?(key)}
    #  redirect_to post_url(redirect_params), :status=>301
    #end
  end

  def subscribe
    Subscriber.create({:user_id => current_user[:id], :post_id => params[:id]}) unless params[:id].nil? && current_user[:id].nil?
    render :json => {:success => true} 
  end

  def unsubscribe
    Subscriber.destroy_all({:user_id => current_user[:id], :post_id => params[:id]}) unless params[:id].nil? && current_user[:id].nil?
    render :json => {:success => true}
  end


  def test
    params = {:year => "2010", :month => "08", :day => "02", :url => "metallist-metallurg-donetsk-metallist-harkov-0-3"}
    @post = Post.find(:first, :conditions => ["YEAR(created_at) = :year AND MONTH(created_at) = :month AND DAY(created_at) = :day AND url = :url ", params])
  end
end
