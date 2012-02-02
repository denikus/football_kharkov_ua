# -*- encoding : utf-8 -*-
class VenuesController < ApplicationController
  layout 'application'

  # GET /users/1
  # GET /users/1.xml
  def show
    @venue = Venue.from_param(params[:id])
    @page_title = @venue.page_title 
#    render :layout => "user"
  end
end
