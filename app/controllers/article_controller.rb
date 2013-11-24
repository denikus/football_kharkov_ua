# -*- encoding : utf-8 -*-
class ArticleController < ApplicationController
#before_filter :authorize, :except => [:show]
before_filter :authenticate_user!, :except => [:show]
before_filter :check_permissions, :except => [:show, :new, :create, :upload_image]

  def new
    @article = Article.new
    @article_image = ArticleImage.new
    render :layout => "app_without_sidebar"
  end

  def create
    @article = Article.new(params[:article])
    @post = Post.new({:author_id=>current_user[:id],
                      :title => params[:post][:title],
                      :status => params[:post][:status],
                      :hide_comments => params[:post][:hide_comments],
                      :tournament_id => params[:post][:tournament_id]
                     })

    @post.resource = @article
    respond_to do |format|
      if @post.save
        flash[:notice] = "Статья успешно сохранена"
        format.html { redirect_to(:controller => 'blog', :action => 'index') }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @article = Article.find(params[:id])
    @article_image = @article.article_image
    render :layout => "app_without_sidebar"
  end

  def update
    @article = Article.find(params[:id])
    respond_to do |format|

      if @article.update_attributes(params[:article]) && @article.post.update_attributes(params[:post])
        flash[:notice] = "Статья успешно сохранена"
        format.html { redirect_to(:controller => 'blog', :action => 'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
      @article = Article.find(params[:id])
      respond_to do |format|
        if user_signed_in? && current_user[:id]==1
          if @article.post.resource.destroy
            flash[:notice] = "Статья успешно удалена"
            format.html { redirect_to(:controller => 'blog', :action => 'index') }
            format.xml  { head :ok }
          else
            format.html { render :action => "edit", :id => params[:id] }
            format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
          end
        end
      end
  end

  def show
    @article = Article.find(params[:id])
  end

  def upload_image
    picture_path = RAILS_ROOT + '/public/user/' + current_user[:id].to_s + '/images/'
    picture = Picture.new
    picture.prepare_directory(RAILS_ROOT + '/public/user/' + current_user[:id].to_s)
    picture.prepare_directory(picture_path)
    picture.set_picture_path(picture_path)
    picture.save(params['file'])

    result = {:result => 'success', :path => '/user/' + current_user[:id].to_s + '/images/' + params['file'].original_filename}

    render :text => result.to_json, :layout=> false
  end

  private
  
  def check_permissions
    article = Article.find(params[:id])
    post = article.post
    if post.author_id!=current_user[:id] && current_user[:id] != 1
      flash[:error] = "Недостаточно прав для данного действия!"
      redirect_to post_url({:year => post.created_at.strftime('%Y'), :month => post.created_at.strftime('%m'), :day => post.created_at.strftime('%d'), :url => !post.url.nil? ? post.url : ''})
    end
  end

end
