class Admin::MatchEventTypesController < ApplicationController
  layout 'admin/main'
  
  admin_section :tournaments
  
  def index
    types = MatchEventType.find(:all) do
      paginate :page => params[:page], :per_page => params[:rows]
    end
    respond_to do |format|
      format.html
      format.json do
        render :json => types.to_jqgrid_json([:id, :symbol, :template], params[:page], params[:rows], types.total_entries)
      end
    end
  end
  
  def grid_edit
    params[:format] = 'json'
    params[:match_event_type] = [:symbol, :template].inject({}){ |p, k| p[k] = params.delete(k); p }
    case params[:oper].to_sym
    when :add: create
    when :del: destroy
    when :edit: update
    end
  end

  def create
    @type = MatchEventType.new(params[:match_event_type])
    respond_to do |format|
      if @type.save
        format.json { render :json => {:success => true} }
      else
        format.json{ render :json => {:success => false} }
      end
    end
  end
  
  def update
    @type = MatchEventType.find params[:id]
    
    respond_to do |format|
      if @type.update_attributes(params[:match_event_type])
        format.json  { render :json => {:success => true} }
      else
        format.json { render  :json => {:success => false} }
      end
    end
  end
  
  def destroy
    @type = MatchEventType.find params[:id]
    @type.destroy
    
    respond_to do |format|
      format.json{ render :json => {:success => true} }
    end
  end
end
