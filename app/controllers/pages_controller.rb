# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  def show
    if request.subdomain.empty?
      @page = Page.from_param(params[:id])
    else
      @page = Page.where(["pages.url = ? AND tournaments.url = ? ", params[:id], request.subdomain]).joins(:tournament).first
    end
    @page_title = @page.title

    unless request.subdomain.nil?
      render :layout => "app_without_sidebar"
    end
  end
end
