class Api::V1::NewsController < ApplicationController
  before_filter :find_tournament

  def index
    params[:page] ||= 1
    params[:per_page] ||= 10

    posts_count = @tournament.posts.count
    @posts = @tournament.posts.paginate(page: params[:page], per_page: params[:per_page]).order('created_at DESC').collect{|item|
            {
              id: item.id,
              created_at: item.created_at,
              updated_at: item.updated_at,
              title: item.title,
              author: item.user.username,
              comments_count: item.comments.count
            }
    }

    respond_to do |format|
      format.json{ render json: {news_count: posts_count, news: @posts} }
    end
  end

  def show
    @post = Post.find(params[:id])

    response = {
        id: @post.id,
        created_at: @post.created_at,
        updated_at: @post.updated_at,
        title: @post.title,
        body: ActiveSupport::Base64.encode64(@post.resource.body),
        author: @post.user.username,
        comments_count: @post.comments.count
    }


    respond_to do |format|
      format.json{ render json: response }
    end
  end

  #def show
  #  ap @post = Post.find(params[:id])
  #  #rescue ActiveRecord::RecordNotFound
  #  #  error = { :error => "The news you were looking for could not be found."}
  #  #  respond_with(error, :status => 404)
  #  puts "!!!!!!!!!!!!!!!"
  #  ap response = {
  #      id: @post.id,
  #      created_at: @post.created_at,
  #      updated_at: @post.updated_at,
  #      title: @post.title,
  #      body: @post.body,
  #      author: @post.user.username,
  #      comments_count: @post.comments.count
  #  }
  #
  #
  #  respond_to do |format|
  #    format.json{ render json: response }
  #  end
  #end

  private

  def find_tournament
    @tournament = Tournament.find_by_url(params[:tournament_id])
    rescue ActiveRecord::RecordNotFound
      error = { :error => "The tournament you were looking for could not be found."}
      respond_with(error, :status => 404)
  end
end
