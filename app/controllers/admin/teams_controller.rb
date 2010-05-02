class Admin::TeamsController < ApplicationController
  def index
    prepare_team = lambda{ |item|
      {:id => item[:id], :name => item[:name], :url => item[:url]}
    }
    result = unless params[:league_id].nil?
      teams = League.find(params[:league_id]).teams
      {:total_count => teams.length, :rows => teams.collect(&prepare_team) }
    else
      start = (params[:start] || 0).to_i
      size = (params[:limit] || 30).to_i
      page = (start/size).to_i + 1
      
      teams = Team.paginate(:all, :page => page, :per_page => size)
      {:total_count => Team.count, :rows => teams.collect(&prepare_team)}
    end
    
    render :json => result.to_json
  end
  
  def update
    @team = Team.find(params[:id])
    @team.footballer_ids = params[:footballer_ids].split(',').collect(&:to_i)
    
    respond_to do |format|
      if @team.save
        format.html { redirect_to(admin_teams_path) }
        format.json  { render :json => {:success => true} }
      else
        format.html { redirect_to(admin_teams_path) }
        format.json { render  :json => @team.to_ext_json(:success => false) }
      end
    end
  end

  def create
    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
        format.ext_json  { render :json => {:success => true} }
#        format.ext_json { render :json => Post.find(:all).to_ext_json }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @team.to_ext_json(:success => false) }

      end
    end
  end
end
