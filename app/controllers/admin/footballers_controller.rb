class Admin::FootballersController < ApplicationController
  def index
    prepare_footballer = lambda{ |item|
      {:id => item[:id], :first_name => item[:first_name], :last_name => item[:last_name], :patronymic => item[:patronymic], :full_name => item.full_name}
    }
    
    result = unless params[:team_id].nil?
      footballers = Team.find(params[:team_id]).footballers
      {:total_count => footballers.length, :rows => footballers.collect(&prepare_footballer) }
    else
      start = (params[:start] || 0).to_i
      size = (params[:limit] || 30).to_i
      page = (start/size).to_i + 1
      
      footballers = Footballer.paginate(:all, :page => page, :per_page => size)
      {:total_count => Footballer.count, :rows => footballers.collect(&prepare_footballer)}
    end
    
    render :json => result.to_json
  end

  def create
    @footballer = Footballer.new(params[:footballer])

    respond_to do |format|
      if @footballer.save
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @footballer, :status => :created, :location => @footballer }
        format.ext_json  { render :json => {:success => true} }
#        format.ext_json { render :json => Post.find(:all).to_ext_json }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @footballer.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @footballer.to_ext_json(:success => false) }

      end
    end
  end
  
end
