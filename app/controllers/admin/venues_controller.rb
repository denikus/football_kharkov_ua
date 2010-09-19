class Admin::VenuesController < ApplicationController
  layout 'admin/main'

  admin_section :tournaments
  
  def index
    venues = Venue.find(:all) do
      paginate :page => params[:page], :per_page => params[:rows]
    end
    respond_to do |format|
      format.html
      format.json do
        render :json => venues.to_jqgrid_json([:id, :name, :short_name, :url, :icon], params[:page], params[:rows], venues.total_entries)
      end
    end
  end

  def grid_edit
    params[:format] = 'json'
    params[:venue] = [:name, :short_name, :url, :icon].inject({}){ |p, k| p[k] = params.delete(k); p }
    case params[:oper].to_sym
    when :add: create
    when :del: destroy
    when :edit: update
    end
  end

  def create
    @venue = Venue.new(params[:venue])
    respond_to do |format|
      if @venue.save
        format.json { render :json => {:success => true} }
      else
        format.json{ render :json => {:success => false} }
      end
    end
  end

  def update
    @venue = Venue.find params[:id]

    respond_to do |format|
      if @venue.update_attributes(params[:venue])
        format.html { redirect_to([:admin, @venue]) }
        format.json  { render :json => {:success => true} }
      else
        format.html { redirect_to([:admin, @venue]) }
        format.json { render  :json => @venue.to_ext_json(:success => false) }
      end
    end
  end

  def destroy
    @venue = Venue.find params[:id]
    @venue.destroy

    respond_to do |format|
      format.html{ redirect_to admin_venues_path }
      format.json{ render :json => {:success => true} }
    end
  end
  
end
