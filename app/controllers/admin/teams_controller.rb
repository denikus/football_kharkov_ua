class Admin::TeamsController < ApplicationController
  layout 'admin/main'
  admin_section :personnel
  
  def index
    if params[:tournament_id]
      @tournament = Tournament.from params[:tournament_id]
      render :action => 'leagues', :section => :tournaments
    elsif params[:league_id]
      @league = League.find params[:league_id]
      render :update do |page|
        page[:teams_selection].replace_html :partial => 'league_teams'
      end
    elsif params[:season_id]
      @season = Season.find params[:season_id]
      render :update do |page|
        page[:teams_selection].replace_html :partial => 'season_teams'
      end
    else
      teams = Team.find(:all) do
        paginate :page => params[:page], :per_page => params[:rows]
      end
      respond_to do |format|
        format.html
        format.json do
          render :json => teams.to_jqgrid_json([:id, :name, :url], params[:page], params[:rows], teams.total_entries)
        end
      end
    end
  end
  
  def grid_edit
    params[:format] = 'json'
    destroy if params[:oper].to_sym == :del
  end
  
  def new
  end
  
  def edit
    @team = Team.find(params[:id])
  end
  
  def update
    @team = Team.find(params[:id])
    
    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to(admin_teams_path) }
      else
        format.html { redirect_to(admin_teams_path) }
      end
    end
  end

  def create
    @team = Team.new(params[:team])
    
    respond_to do |format|
      if @team.save
        format.html { redirect_to(admin_teams_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def destroy
    @team = Team.find params[:id]
    @team.destroy
    
    respond_to do |format|
      format.html{ redirect_to admin_teams_path }
    end
  end

  def team_2_season
    if params[:tournament_id]
      @tournament = Tournament.from params[:tournament_id]
      render :action => 'team_2_season', :section => :tournaments
    end
  end
end
