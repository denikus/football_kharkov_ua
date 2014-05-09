# -*- encoding : utf-8 -*-
class StatusesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  def new
    @status = Status.new
  end

  def create
    if MEGA_USER.include?(current_user.id)
      post_params = params[:post].merge({:author_id => current_user.id})
      @status = Status.new(params[:status])

      @post = Post.new(post_params)
      @post.resource = @status
      respond_to do |format|
        if @post.save
          flash[:notice] = "Статус успешно сохранен"
          format.html { redirect_to(:controller => 'blog', :action => 'index') }
          format.xml  { render :xml => @post, :status => :created, :location => @post }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
        end
      end
    end  
  end

  def show

    @post = Status.find(params[:id]).post

    @page_title = @post.title
    if !@post.tournament.nil? && request.subdomain.nil?
      redirect_params = {:host => with_subdomain(@post.tournament.url) }
      redirect_params.merge!(params)
      redirect_params.delete_if {|key,value| !["year", "month", "day", "url", :host].include?(key)}
      redirect_to status_url(redirect_params), :status=>301
    end
  end

  def destroy
    
  end

  def update
    
  end
end
