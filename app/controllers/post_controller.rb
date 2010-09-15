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
    @post = Post.find(:first, :conditions => ["YEAR(created_at) = :year AND MONTH(created_at) = :month AND DAY(created_at) = :day AND url = :url ", params])
    @page_title = @post.title


    if !@post.tournament.nil? && current_subdomain.nil?
      redirect_params = {:subdomain => @post.tournament.url}
      redirect_params.merge!(params)

      redirect_params.delete_if {|key,value| !["year", "month", "day", "url", :subdomain].include?(key)}
      redirect_to subdomain_post_url(redirect_params), :status=>301
    end
  end

  def subscribe
    Subscriber.create({:user_id => current_user[:id], :post_id => params[:id]}) unless params[:id].nil? && current_user[:id].nil?
    render :json => {:success => true} 
  end

  def unsubscribe
    Subscriber.destroy_all({:user_id => current_user[:id], :post_id => params[:id]}) unless params[:id].nil? && current_user[:id].nil?
    render :json => {:success => true}
  end
  
end
