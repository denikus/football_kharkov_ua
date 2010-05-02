class Admin::LeaguesController < ApplicationController
  def index
    prepare_league = lambda{ |item|
      {:id => item[:id], :name => item[:name], :url => item[:url], :stage => item.stage.name}
    }
    result = unless params[:stage_id].nil?
      leagues = Stage.find(params[:stage_id]).leagues
      {:total_count => leagues.length, :rows => leagues.collect(&prepare_league) }
    else
      start = (params[:start] || 0).to_i
      size = (params[:limit] || 30).to_i
      page = (start/size).to_i + 1
      
      leagues = League.paginate(:all, :page => page, :per_page => size, :joins => :stage)
      {:total_count => League.count, :rows => leagues.collect(&prepare_league)}
    end
    
    render :json => result.to_json
  end
  
  def update
    @league = League.find(params[:id])
    @league.team_ids = params[:team_ids].split(',').collect(&:to_i)
    
    respond_to do |format|
      if @league.save
        format.html { redirect_to(admin_leagues_path) }
        format.json  { render :json => {:success => true} }
      else
        format.html { redirect_to(admin_leagues_path) }
        format.json {render  :json => @league.to_ext_json(:success => false) }
      end
    end
  end

  def create
    @league = League.new(params[:league])

    respond_to do |format|
      if @league.save
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @league, :status => :created, :location => @league }
        format.ext_json  { render :json => {:success => true} }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @league.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @league.to_ext_json(:success => false) }
      end
    end
  end

end
