require 'secured.rb'

class Admin::TournamentsController < ApplicationController
  include Secured
  
  layout 'admin/main'
  
  before_filter :authenticate_admin!
  before_filter permit :admin
  
  def index
    respond_to do |format|
      format.html
      format.json do
        tournaments = Tournament.all(:include => :step_seasons)
        data = tournaments.collect do |t|
          { :text => t.name,
            :cls => 'folder',
            :children => t.step_seasons.collect{ |s| {:text => s.full_name, :leaf => true, :step_id => s.id} }
          }
        end
        render :json => data
      end
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
  
  secure :create
end
