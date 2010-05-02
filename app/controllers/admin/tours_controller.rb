class Admin::ToursController < ApplicationController
  def index
    prepare_tour = lambda{ |item|
      {:id => item.id, :league_id => item.league_id, :name => item.name}
    }
    result = unless params[:league_id].nil?
      tours = League.find(params[:league_id]).tours
      {:total_count => tours.length, :rows => tours.collect(&prepare_tour) }
    else
      start = (params[:start] || 0).to_i
      size = (params[:limit] || 30).to_i
      page = (start/size).to_i + 1
      
      tours = Tour.paginate(:all, :page => page, :per_page => size)
      {:total_count => Tour.count, :rows => tours.collect(&prepare_tour)}
    end
    
    render :json => result.to_json
  end

  def create
    @tour = Tour.new(params[:tour])
    
    respond_to do |format|
      if @tour.save
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @tour, :status => :created, :location => @tour }
        format.ext_json  { render :json => {:success => true} }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tour.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @tour.to_ext_json(:success => false) }
      end
    end
  end
  
  def table
    @records = Tour.find(params[:id]).tour_table.get
    render :layout => false
  end
end
