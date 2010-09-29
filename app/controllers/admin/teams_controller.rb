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
      unless params[:competitor_team_id].nil?
        #select teams in same league as current
        respond_to do |format|
          competitor = Team.find(:first,
                  :select => "teams.*, leagues.id AS league_id",
                  :joins => "INNER JOIN leagues_teams ON (leagues_teams.team_id = teams.id) " +
                            "INNER JOIN leagues ON (leagues_teams.league_id = leagues.id) " +
                            "INNER JOIN stages ON (stages.id = leagues.stage_id) " +
                            "INNER JOIN seasons ON (seasons.id = stages.season_id) ",
                  :conditions => ["teams.id = ? AND seasons.id = ?", params[:competitor_team_id], params[:season_id] ])
          #search teams in same league
          @competitor_teams = Team.find(:all,
                   :joins => "INNER JOIN leagues_teams ON (leagues_teams.team_id = teams.id) ",
                   :conditions => ["leagues_teams.league_id = ? and leagues_teams.team_id != ?", competitor[:league_id], params[:competitor_team_id]]
                  )
  #        teams.each do |item|
  #          result_data << {:id => item[:id], :label => item[:name]}
  #        end
          format.js do
            render :update do |page|
              page.replace_html :schedule_guest_team_id, :partial => 'competitor_teams', :object => @competitor_teams
            end
          end
        end
#        respond_to do |format|
#          format.json {render :text => result_data.to_json, :layout => false}
#        end
      else
        @season = Season.find params[:season_id]
        render :update do |page|
          page[:teams_selection].replace_html :partial => 'season_teams'
        end
      end
    else
      teams = Team.find(:all) do
        paginate :page => params[:page], :per_page => params[:rows], :order => "last_name ASC"
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
