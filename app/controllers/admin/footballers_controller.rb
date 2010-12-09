class Admin::FootballersController < ApplicationController
  layout 'admin/main'
  
  def index
    if params[:team_id]
      team = Team.find(params[:team_id])
      team.season_id = params[:season_id].to_i
      render :update do |page|
        page[:footballers].replace_html :partial => 'team_footballers', :locals => {:team => team}
      end
    else
      respond_to do |format|
        format.html
        format.json do
          footballers = Footballer.all
          render :json => {
            'personnel' => footballers.map{ |f| Hash[*%w{id first_name last_name patronymic birth_date url name}.tap{ |a| a.replace a.zip(a.map{ |m| f.send(m) }).flatten }] },
            'count' => footballers.length
          }
        end
      end
    end
  end
  
  def create
    @footballer = Footballer.new(params[:footballers])
    respond_to do |format|
      if @footballer.save
        format.json { render :json => {:success => true} }
      else
        format.json{ render :json => {:success => false} }
      end
    end
  end
  
  def update
    @footballer = Footballer.find params[:id]
    
    respond_to do |format|
      if @footballer.update_attributes(params[:footballers])
        format.json  { render :json => {:success => true} }
      else
        format.json { render  :json => @footballer.to_ext_json(:success => false) }
      end
    end
  end
  
  def destroy
    @footballer = Footballer.find params[:id]
    @footballer.destroy
    
    respond_to do |format|
      format.json{ render :json => {:success => true} }
    end
  end
  
end
