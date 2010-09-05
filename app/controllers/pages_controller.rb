class PagesController < ApplicationController
  def show
    render(:partial => "contacts", :layout => "application") unless params[:id]!='contacts'
  end
end
