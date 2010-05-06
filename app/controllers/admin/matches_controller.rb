class Admin::MatchesController < ApplicationController
  def index
    start = (params[:start] || 0).to_i
    size = (params[:limit] || 30).to_i
    page = (start/size).to_i + 1
    
    matches = Match.paginate(:all,
      :conditions => ['tour_id = ?', params[:tour_id]],
      :include => {:competitors => :team},
      :page => page,
      :per_page => size
    )
    result = {
      :total_count => matches.length,
      :rows => matches.collect do |m|
        {
          :id => m.id,
          :tour => m.tour.name,
          :date => m.played_at,
          :hosts => m.hosts.team.name,
          :guests => m.guests.team.name,
          :score => "#{m.hosts.stats.score} - #{m.guests.stats.score}"
        }
      end
    }
    render :json => result.to_json
  end

  def create
    @match = Match.create_from_form params[:match]
    respond_to do |format|
      if @match.save
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @match, :status => :created, :location => @match }
        format.ext_json  { render :json => {:success => true} }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @match.to_ext_json(:success => false) }
      end
    end
  end
  
  def update_fouls
    @match = Match.find(params[:id])
    
    @match.hosts.update_attributes(params[:hosts])
    @match.guests.update_attributes(params[:guests])
    
    render :json => {:success => false}.to_json
  end
end
