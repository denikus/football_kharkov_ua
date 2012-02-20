# -*- encoding : utf-8 -*-
class Admin::MatchEventsController < ApplicationController
  def index
    events = MatchEvent.find_all_by_match_id(params[:match_id], :select => 'id, minute, message', :order => 'minute DESC')
    
    render ext_success(:data => events)
  end
  
  def update
    data = ActiveSupport::JSON.decode params[:data]
    event = MatchEvent.find data['id']
    
    render event.update_attributes(data) ? ext_success : ext_failure
  end
  
  def create
    data = ActiveSupport::JSON.decode params[:data]
    event = MatchEvent.new data.merge('match_id' => params[:match_id])
    
    render event.save ? ext_success(:id => event.id) : ext_failure
  end
  
  def destroy
    MatchEvent.find(params[:id]).destroy
    render ext_success
  end
end
