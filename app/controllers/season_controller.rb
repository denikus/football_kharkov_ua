class SeasonController < ApplicationController
  def index
    seasons = Season.find(:all, :conditions => {:tournament_id => params[:tournament][:id] })
    result_data = []
    seasons.each do |item|
      result_data << {:id => item[:id], :label => item[:name]}
    end
    respond_to do |format|
      format.json {render :text => result_data.to_json, :layout => false}
    end
  end
end
