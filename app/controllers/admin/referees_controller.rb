class Admin::RefereesController < ApplicationController
  layout 'admin/main'
  
  admin_section :personnel
  
  def index
    referees = Referee.find(:all) do
      paginate :page => params[:page], :per_page => params[:rows]
    end
    respond_to do |format|
      format.html
      format.json do
        render :json => referees.to_jqgrid_json([:id, :first_name, :last_name, :patronymic, :birth_date], params[:page], params[:rows], referees.total_entries)
      end
    end
  end
  
  def grid_edit
    params[:format] = 'json'
    params[:referee] = [:first_name, :last_name, :patronymic, :birth_date].inject({}){ |p, k| p[k] = params.delete(k); p }
    case params[:oper].to_sym
    when :add: create
    when :del: destroy
    when :edit: update
    end
  end

  def create
    @referee = Referee.new(params[:referee])
    respond_to do |format|
      if @referee.save
        format.json { render :json => {:success => true} }
      else
        format.json{ render :json => {:success => false} }
      end
    end
  end
  
  def update
    @referee = Referee.find params[:id]
    
    respond_to do |format|
      if @referee.update_attributes(params[:referee])
        format.html { redirect_to([:admin, @referee]) }
        format.json  { render :json => {:success => true} }
      else
        format.html { redirect_to([:admin, @referee]) }
        format.json { render  :json => @referee.to_ext_json(:success => false) }
      end
    end
  end
  
  def destroy
    @referee = Referee.find params[:id]
    @referee.destroy
    
    respond_to do |format|
      format.html{ redirect_to admin_referees_path }
      format.json{ render :json => {:success => true} }
    end
  end
end
