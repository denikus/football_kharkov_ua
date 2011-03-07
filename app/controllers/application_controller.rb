class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery

#  def current_subdomain
#    request.subdomain.empty? ? nil : request.subdomain
#  end
end
