# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  def show
    if request.subdomain.nil?
      @page = Page.from_param(params[:id])
    else
      @page = Page.find(:first,
                        :joins => :tournament,
                        :conditions => ["pages.url = ? AND tournaments.url = ? ", params[:id], request.subdomain])
    end
    @page_title = @page.title

    unless request.subdomain.nil?
      render :layout => "app_without_sidebar"
    end
  end
end
