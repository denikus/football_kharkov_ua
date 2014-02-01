# -*- encoding : utf-8 -*-
class ArticleController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  def new
    @article = Article.new
    @article_image = ArticleImage.new
    render :layout => "app_without_sidebar"
  end

  def create
    @post = Post.new({:author_id=>current_user[:id],
                      :title => params[:post][:title],
                      :status => params[:post][:status],
                      :hide_comments => params[:post][:hide_comments],
                      :tournament_id => params[:post][:tournament_id]
                     })

    @post.resource = Article.new(params[:article])

    authorize @post, :update?

    respond_to do |format|
      if @post.save
        flash[:notice] = "Статья успешно сохранена"
        format.html { redirect_to(:controller => 'blog', :action => 'index') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @article = Article.find(params[:id])

    authorize @article.post, :update?

    @article_image = @article.article_image
    render :layout => "app_without_sidebar"
  end

  def update
    @article = Article.find(params[:id])

    authorize @article.post, :update?

    respond_to do |format|

      if @article.update_attributes(params[:article]) && @article.post.update_attributes(params[:post])
        flash[:notice] = "Статья успешно сохранена"
        format.html { redirect_to(:controller => 'blog', :action => 'index') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def delete
      @article = Article.find(params[:id])

      authorize @article.post, :update?

      respond_to do |format|
        if user_signed_in? && current_user[:id]==1
          if @article.post.resource.destroy
            flash[:notice] = "Статья успешно удалена"
            format.html { redirect_to(:controller => 'blog', :action => 'index') }
          else
            format.html { render :action => "edit", :id => params[:id] }
          end
        end
      end
  end

  def show
    @article = Article.find(params[:id])
  end

end
