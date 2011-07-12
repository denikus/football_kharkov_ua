class Admin::StepsController < ApplicationController
  before_filter :authenticate_admin!
  
  def index
    request.xhr? ? show : return
  end
  
  def show
    root, params[:id], params[:type] = $1, $2, $3 if params[:node] =~ /^nav-tournament-(?:(root)|(?:(\d+)-?(\w+)?))$/
    @node = root ? Tournament.from(params[:tournament_id]) : Step.find(params[:id])

    render :action => 'show.ext.haml', :layout => false
  end
  
  def create
    if params[:step][:step_properties][:playoff]=="on"
      params[:step][:step_properties_attributes] = [{:property_name => "playoff", :property_value => 1}]
      params[:step].delete("step_properties")
    end

    assoc = params[:step][:type][/Step(\w+)/, 1].downcase.pluralize
    klass = params[:step].delete(:type).constantize
    parent_id = params[:step].delete(:parent_id)
    parent_id = nil if parent_id == 'root'
    
    step = klass.create params[:step]
    Step.find(parent_id).send(assoc).push(step) if parent_id
    
    render ext_success
  end
  
  def update
    [:type, :parent_id].each{ |p| params[:step].delete p }

    step = Step.find(params[:id])

    if step.is_a? StepStage then
      step.is_playoff =  params[:step][:playoff]  == 'on'
    end

    if params[:step][:playoff] then
      params[:step].delete :playoff
    end

    step.update_attributes params[:step]
    render ext_success
  end
  
  def destroy
    Step.find(params[:id]).destroy
    render ext_success
  end
  
  def teams
    team_ids = Step.find(params[:id]).team_ids
    teams = Team.all(:order => 'name ASC').map{ |t| {:id => t[:id], :name => t[:name], :url => t[:url]} }
    selected = teams.select{ |t| team_ids.include? t[:id] }
    remaining = teams - selected
    render :json => {
      'selected' => selected,
      'remaining' => remaining,
      'selected_count' => selected.length,
      'remaining_count' => remaining.length
    }
  end
  
  def update_teams
    Step.find(params[:id]).team_ids = params[:team_ids].split(',').map(&:to_i)
    render ext_success
  end
end
