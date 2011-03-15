class Admin::SeasonsController < ApplicationController
  layout 'admin/main'
#  admin_section :tournaments
  
  def index
    @tournament = Tournament.from params[:tournament_id]
    seasons = Season.find(:all, :conditions => {:tournament_id => @tournament.id}) do
      paginate :page => params[:page], :per_page => params[:rows]
    end
    respond_to do |format|
      format.html
      format.json do
        render :json => seasons.to_jqgrid_json([:id, :name, :url], params[:page], params[:rows], seasons.total_entries)
      end
    end
  end
  
  def grid_edit
    params[:format] = 'json'
    @tournament = Tournament.from params[:tournament_id]
    params[:season] = [:name, :url].inject({}){ |p, k| p[k] = params.delete(k); p }
    params[:season][:tournament_id] = @tournament.id
    case params[:oper].to_sym
    when :add: create
    when :del: destroy
    when :edit: update
    end
  end
  
  def update
    @season = Season.find params[:id]
    
    respond_to do |format|
      if @season.update_attributes(params[:season])
        format.json { render :json => {:success => true} }
        format.html { redirect_to(team_2_season_admin_tournament_teams_path(@season.tournament)) }
      else
        format.json { render :json => {:success => false} }
        format.html { redirect_to(team_2_season_admin_tournament_teams_path(@season.tournament)) }
      end
    end
  end

  def create
    @season = Season.new params[:season]
    
    respond_to do |format|
      if @season.save
        format.json { render :json => {:success => true} }
      else
        format.json { render :json => {:success => false} }
      end
    end
    #@season = Season.new(params[:season])
    #
    #respond_to do |format|
    #  if @season.save
    #    format.html { redirect_to(root_path) }
    #    format.xml  { render :xml => @season, :status => :created, :location => @season }
    #    format.ext_json  { render :json => {:success => true} }
    #  else
    #    format.html { render :action => "new" }
    #    format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
    #    format.ext_json {render  :json => @season.to_ext_json(:success => false) }
    #  end
    #end
  end
  
  def destroy
    Season.find(params[:id]).destroy
    render :json => {:success => true}
  end
end
