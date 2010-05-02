class Admin::RefereesController < ApplicationController
  def index
    start = (params[:start] || 0).to_i
    size = (params[:limit] || 30).to_i
    page = (start/size).to_i + 1
    
    referees = Referee.paginate(:all, :page => page, :per_page => size)
    result = {
      :total_count => Referee.count,
      :rows => referees.collect{ |r| {:id => r.id, :first_name => r.first_name, :last_name => r.last_name, :patronymic => r.patronymic, :full_name => r.full_name}  }
    }
    
    render :json => result.to_json
  end

  def create
    @referee = Referee.new(params[:referee])
    
    respond_to do |format|
      if @referee.save
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @referee, :status => :created, :location => @referee }
        format.ext_json  { render :json => {:success => true} }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @referee.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @referee.to_ext_json(:success => false) }
      end
    end
  end
  
end
