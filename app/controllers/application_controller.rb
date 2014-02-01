# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  include Pundit
  include UrlHelper

  protect_from_forgery

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def ext_success data={}
    {:json => {:success => true}.merge(data)}
  end

  def ext_failure
    {:json => {:success => false}}
  end

  private

  def user_not_authorized
    flash[:error] = "У вас недостаточно прав для этого действия!"
    redirect_to request.headers["Referer"] || root_path
  end
end
