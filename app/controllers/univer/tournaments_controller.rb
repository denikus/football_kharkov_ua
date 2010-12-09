class Univer::TournamentsController < ApplicationController
  def show
    @node  = Tournament.from(params[:id])
    render :layout => false
  end
end
