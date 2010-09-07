require 'secured.rb'

class Admin::TournamentsController < ApplicationController
  include Secured
  
  layout 'admin/main'
  admin_section :tournaments
  
  before_filter :authenticate_admin!
  before_filter permit :admin
  
  def index
    tournaments = Tournament.find(:all) do
      paginate :page => params[:page], :per_page => params[:rows]
    end
    respond_to do |format|
      format.html
      format.json do
        render :json => tournaments.to_jqgrid_json([:id, :name, :url], params[:page], params[:rows], tournaments.total_entries)
      end
    end
  end
  
  def grid_edit
    params[:format] = 'json'
    params[:tournament] = [:name, :url].inject({}){ |p, k| p[k] = params.delete(k); p }
    case params[:oper].to_sym
    when :add: create
    when :del: destroy
    when :edit: update
    end
  end

  def create
    @tournament = Tournament.new(params[:tournament])

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to(root_path) }
        format.json { render :json => {:success => true} }
        format.xml  { render :xml => @tournament, :status => :created, :location => @tournament }
        format.ext_json  { render :json => {:success => true} }
#        format.ext_json { render :json => Post.find(:all).to_ext_json }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tournament.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @tournament.to_ext_json(:success => false) }

      end
    end
  end
  
  #def seasons
  #  seasons = Tournament.from_param(params[:id]).seasons
  #  result = {:total_count => seasons.length, :rows => seasons.collect{ |s| {:id => item[:id], :name => item[:name], :url => item[:url]} }}
  #  render :json => result.to_json
  #end
  
  secure :create
end
