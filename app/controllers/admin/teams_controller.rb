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
        #last stage
        respond_to do |format|
          stage = Stage.find(:first,
                             :conditions => ["season_id = ?", params[:season_id]],
                             :order => "number DESC" 
                              )

          competitor = Team.find(:first,
                  :select => "teams.*, leagues.id AS league_id",
                  :joins => "INNER JOIN leagues_teams ON (leagues_teams.team_id = teams.id) " +
                            "INNER JOIN leagues ON (leagues_teams.league_id = leagues.id) " +
                            "INNER JOIN stages ON (stages.id = leagues.stage_id) " +
                            "INNER JOIN seasons ON (seasons.id = stages.season_id) ",
                  :conditions => ["teams.id = ? AND seasons.id = ? AND stage_id = ? ", params[:competitor_team_id], params[:season_id], stage.id ])
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
          if params[:query].nil? || params[:query].empty?
            teams = Team.paginate(:page => 1, :per_page => 10)
          else
            teams = Team.find(:all, :conditions => ["name LIKE(?)", "#{params[:query]}%"])
          end  
          render :json => {
            'personnel' => teams.map{ |t| {'name' => t.name, 'url' => t.url, 'id' => t.id} },
            'count' => teams.length
          }
        end
      end
    end
  end
  
  def update
    @team = Team.find(params[:id])
    
    respond_to do |format|
      if @team.update_attributes(params[:teams])
        format.json { render :json => {:success => true} }
      else
        format.json{ render :json => {:success => false} }
      end
    end
  end

  def create
    @team = Team.new(params[:teams])
    
    respond_to do |format|
      if @team.save
        format.json { render :json => {:success => true} }
      else
        format.json { render :json => {:success => false} }
      end
    end
  end
  
  def destroy
    @team = Team.find params[:id]
    @team.destroy
    
    respond_to do |format|
      format.json { render :json => {:success => true} }
    end
  end

  def team_2_season
    if params[:tournament_id]
      @tournament = Tournament.from params[:tournament_id]
      render :action => 'team_2_season', :section => :tournaments
    end
  end
  
  def footballers
    footballer_ids = Team.find(params[:id]).footballer_ids[params[:step_id]]
    all_footballers = Footballer.all.map{ |f| Hash[*%w{id first_name last_name patronymic birth_date url name}.tap{ |a| a.replace a.zip(a.map{ |m| f.send(m) }).flatten }] }
    if params[:query].nil? || params[:query].empty?
      footballers_with_query = Footballer.paginate(:page => 1, :per_page => 50).map{ |f| Hash[*%w{id first_name last_name patronymic birth_date url name}.tap{ |a| a.replace a.zip(a.map{ |m| f.send(m) }).flatten }] }
    else
      footballers_with_query = Footballer.find(:all, :conditions => ["last_name LIKE(?)", "#{params[:query]}%"]).map{ |f| Hash[*%w{id first_name last_name patronymic birth_date url name}.tap{ |a| a.replace a.zip(a.map{ |m| f.send(m) }).flatten }] }
    end

#    all_footballers

#    footballers = Footballer.all.map{ |f| Hash[*%w{id first_name last_name patronymic birth_date url name}.tap{ |a| a.replace a.zip(a.map{ |m| f.send(m) }).flatten }] }
    selected = all_footballers.select{ |f| footballer_ids.include? f['id'] }
#    selected = footballers.select{ |f| footballer_ids.include? f['id'] }
    remaining = footballers_with_query - selected
#    remaining = footballers - selected
    render :json => {
      'selected' => selected,
      'remaining' => remaining,
      'selected_count' => selected.length,
      'remaining_count' => remaining.length
    }
  end
  
  def update_footballers
    Team.find(params[:id]).footballer_ids[params[:step_id]] = params[:footballer_ids].split(',').map(&:to_i)
    render ext_success
  end
end
