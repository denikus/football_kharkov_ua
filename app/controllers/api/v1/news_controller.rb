class Api::V1::NewsController < Api::V1::BaseController
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::SanitizeHelper

  before_filter :find_tournament

  def index
    params[:page] ||= 1
    params[:per_page] ||= 10

    # return error if params non integer or < 0
    error!("Incorrect params", 403) and return if (params[:page].to_i < 1 || params[:per_page].to_i < 1)

    posts_count = @tournament.posts.count
    @posts = @tournament.posts.paginate(page: params[:page], per_page: params[:per_page]).order('created_at DESC').collect{|item|
            {
              id: item.id,
              created_at: item.created_at,
              updated_at: item.updated_at,
              title: item.title,
              subtitle: strip_tags(truncate(item.resource.body, length: 1000, separator: '<div style="page-break-after: always;">')),
              author: item.user.username,
              comments_count: item.comments.count
            }
    }

    respond_to do |format|
      format.json{ render json: {news_count: posts_count, news: @posts} }
    end
  end

  def show
    @post = Post.find_by_id(params[:id])

    # return error if news not found
    error!("Record not found", 404) and return if @post.blank?

    response = {
        id: @post.id,
        created_at: @post.created_at,
        updated_at: @post.updated_at,
        title: @post.title,
        subtitle: strip_tags(truncate(@post.resource.body, length: 1000, separator: '<div style="page-break-after: always;">')),
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
