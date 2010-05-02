class Admin::StagesController < ApplicationController
  def index
    prepare_stage = lambda{ |item|
      {:id => item[:id], :number => item[:number], :season => item.season[:name], :name => item.name}
    }
    result = unless params[:season_id].nil?
      stages = Season.find(params[:season_id]).stages
      {:total_count => stages.length, :rows => stages.collect(&prepare_stage) }
    else
      start = (params[:start] || 0).to_i
      size = (params[:limit] || 30).to_i
      page = (start/size).to_i + 1
      
      stages = Stage.paginate(:all, :page => page, :per_page => size, :joins => :season)
      {:total_count => Stage.count, :rows => stages.collect(&prepare_stage)}
    end
    
    render :json => result.to_json
  end

  def create
    @stage = Stage.new(params[:stage])

    respond_to do |format|
      if @stage.save
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @stage, :status => :created, :location => @stage }
        format.ext_json  { render :json => {:success => true} }
#        format.ext_json { render :json => Post.find(:all).to_ext_json }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stage.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @stage.to_ext_json(:success => false) }

      end
    end
  end
end
