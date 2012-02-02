# -*- encoding : utf-8 -*-
class Admin::UserRequestsController < ApplicationController
  before_filter :authenticate_admin!

  layout "admin/temp"
  
  def index
    @requests = UserConnectFootballerRequest.includes(:user, :footballer).order("processed ASC, created_at ASC").find(:all)
  end

  def merge
    @request = UserConnectFootballerRequest.find(params[:user_request_id])
    @footballer = Footballer.find(@request.footballer_id)
    unless @footballer.nil?
      if @footballer.merge_user(@request.user_id)
        @request.processed = true
        @request.save
        #todo writing letter
        UserFootballerMerge.successful_merge(@request).deliver
      end
    end
    redirect_to :action => "index"
  end
end
