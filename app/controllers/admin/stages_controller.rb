class Admin::StagesController < ApplicationController
  layout 'admin/main'
  
  def index
    #prepare_stage = lambda{ |item|
    #  {:id => item[:id], :number => item[:number], :season => item.season[:name], :name => item.name}
    #}
    #result = unless params[:season_id].nil?
    #  stages = Season.find(params[:season_id]).stages
    #  {:total_count => stages.length, :rows => stages.collect(&prepare_stage) }
    #else
    #  start = (params[:start] || 0).to_i
    #  size = (params[:limit] || 30).to_i
    #  page = (start/size).to_i + 1
    #  
    #  stages = Stage.paginate(:all, :page => page, :per_page => size, :joins => :season)
    #  {:total_count => Stage.count, :rows => stages.collect(&prepare_stage)}
    #end
    #
    #render :json => result.to_json
    stages = Stage.find(:all, :conditions => {:season_id => params[:id]}) do
      paginate :page => params[:page], :per_page => params[:rows]
    end
    respond_to do |format|
      format.html
      format.json do
        render :json => stages.to_jqgrid_json([:id, :number], params[:page], params[:rows], stages.total_entries)
      end
    end
  end
  
  def grid_edit
    params[:format] = 'json'
    #params[:stage] = [:number].inject({}){ |p, k| p[k] = params.delete(k); p }
    params[:stage] = {:number => params.delete(:number)}
    params[:stage][:season_id] = params[:parent_id] if params[:parent_id]
    case params[:oper].to_sym
    when :add: create
    when :del: destroy
    when :edit: update
    end
  end

  def create
    @stage = Stage.new(params[:stage])
    
    respond_to do |format|
      if @stage.save
        format.html { redirect_to(root_path) }
        format.json { render :json => {:success => true} }
        format.xml  { render :xml => @stage, :status => :created, :location => @stage }
        format.ext_json  { render :json => {:success => true} }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stage.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @stage.to_ext_json(:success => false) }

      end
    end
  end
  
  def update
    @stage = Stage.find params[:id]
    
    respond_to do |format|
      if @stage.update_attributes(params[:stage])
        format.html { redirect_to(admin_stages_path) }
        format.json  { render :json => {:success => true} }
      else
        format.html { redirect_to(admin_stages_path) }
        format.json { render  :json => @team.to_ext_json(:success => false) }
      end
    end
  end
  
  def destroy
    @stage = Stage.find params[:id]
    @stage.destroy
    
    respond_to do |format|
      format.html{ redirect_to admin_stages_path }
      format.json{ render :json => {:success => true} }
    end
  end
end
