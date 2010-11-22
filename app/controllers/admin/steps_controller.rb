class Admin::StepsController < ApplicationController
  layout 'admin/ext_3'
  
  def index
    request.xhr? ? show : return
  end
  
  def show
    params[:id] = $1 if params[:node] =~ /^nav-tournament-(.+)$/
    @parent = params[:id] == 'root' ? Tournament.from(params[:tournament_id]) : Step.find(params[:id])
    @steps = @parent.phases
    render :action => 'show', :layout => false
  end
  
  def create
    klass = params[:step].delete(:type).constantize
    parent_id = params[:step].delete(:parent_id)
    parent_id = nil if parent_id == 'root'
    
    step = klass.create params[:step]
    Step.find(parent_id).phases.push(step) if parent_id
    
    render :json => {:success => true}
  end
  
  def update
    [:type, :parent_id].each{ |p| params[:step].delete p }
    Step.find(params[:id]).update_attributes params[:step]
    render :json => {:success => true}
  end
  
  def destroy
    Step.find(params[:id]).destroy
    render :json => {:success => true}
  end
end
