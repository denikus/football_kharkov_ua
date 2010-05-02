class Admin::SeasonsController < ApplicationController
  def index
    prepare_season = lambda{ |item|
      {:id => item[:id], :name => item[:name], :tournament => item.tournament[:name], :url => item[:url]}
    }
    result = unless params[:tournament_id].nil?
      seasons = Tournament.from_param(params[:tournament_id]).seasons
      {:total_count => seasons.length, :rows => seasons.collect(&prepare_season) }
    else
      start = (params[:start] || 0).to_i
      size = (params[:limit] || 30).to_i
      page = (start/size).to_i + 1
      
      seasons = Season.paginate(:all, :page => page, :per_page => size, :joins => :tournament)
      {:total_count => Season.count, :rows => seasons.collect(&prepare_season)}
    end
    render :json => result.to_json
  end

  def create
    @season = Season.new(params[:season])

    respond_to do |format|
      if @season.save
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @season, :status => :created, :location => @season }
        format.ext_json  { render :json => {:success => true} }
#        format.ext_json { render :json => Post.find(:all).to_ext_json }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @season.to_ext_json(:success => false) }

      end
    end
  end
end
