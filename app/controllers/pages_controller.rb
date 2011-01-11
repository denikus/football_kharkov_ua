class PagesController < ApplicationController
  def show
    if current_subdomain.nil?
      @page = Page.from_param(params[:id])
    else
      @page = Page.find(:first,
                        :joins => :tournament,
                        :conditions => ["pages.url = ? AND tournaments.url = ? ", params[:id], current_subdomain])
    end
    @page_title = @page.title

    unless current_subdomain.nil?
      render :layout => "app_without_sidebar"
    end


  end
end
