class Admin::LeaguesController < ApplicationController
  layout 'admin/main'
  admin_section :tournaments
  
  def index
    @season = Season.find(params[:season_id])
    leagues = League.find(:all, :conditions => {:stages => {:season_id => @season.id}}, :joins => {:stage => :season}, :include => :stage) do
      paginate :page => params[:page], :per_page => params[:rows]
    end
    respond_to do |format|
      format.html
      format.json do
        render :json => leagues.to_jqgrid_json([:id, :stage_number, :name, :url], params[:page], params[:rows], leagues.total_entries)
      end
    end
  end
  
  def grid_edit
    params[:format] = 'json'
    params[:league] = [:name, :url, :stage_id].inject({}){ |p, k| p[k] = params.delete(k); p }
    params[:league][:stage_id] = Stage.create_next(:season_id => params[:season_id]).id if params[:league][:stage_id] and params[:league][:stage_id].empty?
    case params[:oper].to_sym
    when :add: create
    when :del: destroy
    when :edit: update
    end
  end
  
  def update
    @league = League.find(params[:id])
    
    respond_to do |format|
      if @league.update_attributes(params[:league])
        format.json { render :json => {:success => true} }
        format.html { redirect_to(admin_tournament_teams_path(@league.stage.season.tournament)) }
      else
        format.json { render :json => {:success => false} }
        format.html { redirect_to(admin_tournament_teams_path(@league.stage.season.tournament)) }
      end
    end
  end

  def create
    @league = League.new(params[:league])
    
    respond_to do |format|
      if @league.save
        format.html { redirect_to(root_path) }
        format.json  { render :json => {:success => true} }
        format.xml  { render :xml => @league, :status => :created, :location => @league }
        format.ext_json  { render :json => {:success => true} }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @league.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @league.to_ext_json(:success => false) }
      end
    end
  end
  
  def destroy
  end
  
  def table_set
    @set = League.for_table.find(params[:id]).table_set
    render :layout => false
  end

end
