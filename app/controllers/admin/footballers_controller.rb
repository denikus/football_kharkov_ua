class Admin::FootballersController < ApplicationController
  layout 'admin/main'
  
  admin_section :personnel
  
  def index
    if params[:team_id]
      team = Team.find(params[:team_id])
      team.season_id = params[:season_id].to_i
      render :update do |page|
        page[:footballers].replace_html :partial => 'team_footballers', :locals => {:team => team}
      end
    else
      footballers = Footballer.find(:all) do
        paginate :page => params[:page], :per_page => params[:rows]
      end
      respond_to do |format|
        format.html
        format.json do
          render :json => footballers.to_jqgrid_json([:id, :first_name, :last_name, :patronymic, :birth_date], params[:page], params[:rows], footballers.total_entries)
        end
      end
    end
  end
  
  def grid_edit
    params[:format] = 'json'
    params[:footballer] = [:first_name, :last_name, :patronymic, :birth_date].inject({}){ |p, k| p[k] = params.delete(k); p }
    case params[:oper].to_sym
    when :add: create
    when :del: destroy
    when :edit: update
    end
  end

  def create
    @footballer = Footballer.new(params[:footballer])
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
      if @footballer.update_attributes(params[:footballer])
        format.html { redirect_to([:admin, @footballer]) }
        format.json  { render :json => {:success => true} }
      else
        format.html { redirect_to([:admin, @footballer]) }
        format.json { render  :json => @footballer.to_ext_json(:success => false) }
      end
    end
  end
  
  def destroy
    @footballer = Footballer.find params[:id]
    @footballer.destroy
    
    respond_to do |format|
      format.html{ redirect_to admin_footballers_path }
      format.json{ render :json => {:success => true} }
    end
  end
  
end
