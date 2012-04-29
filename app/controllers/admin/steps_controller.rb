# -*- encoding : utf-8 -*-
class Admin::StepsController < ApplicationController
  before_filter :authenticate_admin!
  
  def index
    request.xhr? ? show : return
  end
  
  def show
    root, params[:id], params[:type] = $1, $2, $3 if params[:node] =~ /^nav-tournament-(?:(root)|(?:(\d+)-?(\w+)?))$/
    @node = root ? Tournament.from(params[:tournament_id]) : Step.find(params[:id])
  #  nodes, name, type = case @node
  #    when Tournament
  #      [:steps, 'Сезон', 'StepSeason']
  #    when StepSeason
  #      [:steps, 'Этап', 'StepStage']
  #    when StepStage
  #      case params[:type]
  #        when 'leagues'
  #          [:leagues, 'Лигу', 'StepLeague']
  #        when 'tours'
  #          [:tours, 'Тур', 'StepTour']
  #        else [[{:text => 'Лиги', :cls => 'folder', :id => "nav-tournament-#{@node.id}-leagues"}, {:text => 'Туры', :cls => 'folder', :id => "nav-tournament-#{@node.id}-tours"}], nil, nil]
  #      end
  #  end
  #
  #if @node.is_a? StepTour
  #  season_id = @node.stage.season.id
  #  nodes = @node.schedules.all(:include => {:match => {:competitors => {:team => :footballers_teams}}}).map do |s|
  #    ap s.match
  #    debugger
  #  end
      #ap {:text => s.match.hosts.team.name + " - " + s.match.guests.team.name, :cls => 'leaf', :id => "nav-tournament-schedule-#{s.id}", :leaf => true, '_type' => 'Schedule', '_id' => s.id, '_match_id' => s.match.id, '_hosts' => s.match.hosts.team.name, '_guests' => s.match.guests.team.name, '_hosts_footballer_ids' => s.match.hosts.team.footballer_ids[season_id]*',', '_guests_footballer_ids' => s.match.guests.team.footballer_ids[season_id]*','}
    #end
  #end
    render :action => 'show.ext.haml', :layout => false
  end
  
  def create
    if !params[:step][:step_properties].nil? && params[:step][:step_properties][:playoff]=="on"
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

    process_step_properties(step)

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

  private
    def process_step_properties(step)
      if step.is_a? StepStage
        step.playoff = params[:step][:playoff] == 'on'
      end

      if step.is_a? StepLeague
        step.is_bonus_point = params[:step][:bonus_point] == 'on'
      end

    ["playoff", "bonus_point"].each{|item| params[:step].delete(item)}
  end
end
