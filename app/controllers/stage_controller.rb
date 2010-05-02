class StageController < ApplicationController
  def index
    stages = Stage.find(:all, :conditions => {:season_id => params[:season][:id] })
    result_data = []
    stages.each do |item|
      result_data << {:id => item[:id], :label => item[:number]}
    end
    respond_to do |format|
      format.json {render :text => result_data.to_json, :layout => false}
    end
  end
end
