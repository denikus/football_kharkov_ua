class Admin::CommentsController < ApplicationController
  before_filter :authenticate_admin!
  
  def index
    start = (params[:start] || 0).to_i
    size = (params[:limit] || 30).to_i
    page = (start/size).to_i + 1
    
    comments = Comment.paginate(:all,
                                :page => page,
                                :per_page => size,
                                :include => :user)
    result = {:total_count => Comment.count, :rows => comments.collect{ |item| {:id => item['id'], :author => 'den', :date => item[:created_at]} }}
    render :json => result.to_json
  end
end
