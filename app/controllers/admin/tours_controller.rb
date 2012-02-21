# -*- encoding : utf-8 -*-
class Admin::ToursController < ApplicationController
  def index
    tours = Tour.find(:all, :conditions => {:league_id => params[:id]}) do
      paginate :page => params[:page], :per_page => params[:rows]
    end
    respond_to do |format|
      format.html
      format.json do
        render :json => tours.to_jqgrid_json([:id, :name], params[:page], params[:rows], tours.total_entries)
      end
    end
  end
  
  def grid_edit
    params[:format] = 'json'
    params[:tour] = [:name].inject({}){ |p, k| p[k] = params.delete(k); p }
    params[:tour][:league_id] = params.delete(:parent_id) if params.key?(:parent_id)
    case params[:oper].to_sym
      when :add
        create
      when :del
        destroy
      when :edit
        update
    end
  end

  def create
    @tour = Tour.new(params[:tour])
    
    respond_to do |format|
      if @tour.save
        format.json  { render :json => {:success => true} }
        format.ext_json  { render :json => {:success => true} }
      else
        format.html { render :action => "new" }
        format.ext_json {render  :json => @tour.to_ext_json(:success => false) }
      end
    end
  end
  
  def destroy
    @tour = Tour.find params[:id]
    @tour.destroy
    
    respond_to do |format|
      format.json{ render :json => {:success => true} }
    end
  end
  
  def table
    @records = Tour.find(params[:id]).tour_table.get
    render :layout => false
  end
end
