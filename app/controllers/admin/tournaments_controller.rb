require 'secured.rb'

class Admin::TournamentsController < ApplicationController
  include Secured
  
  before_filter :authenticate_admin!
  before_filter permit :admin
  
  def index
    start = (params[:start] || 0).to_i
    size = (params[:limit] || 30).to_i
    page = (start/size).to_i + 1
    
    rows = Tournament.paginate(:all,
                                :page => page,
                                :per_page => size
                              )
    result = {:total_count => Tournament.count, :rows => rows.collect{ |item| {:id => item[:id], :name => item[:name], :url => item[:url]} }}
    
    render :json => result.to_json
  end

  def create
    @tournament = Tournament.new(params[:tournament])

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to(root_path) }
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
