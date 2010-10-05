class Admin::MatchesController < ApplicationController
  layout 'admin/main'
  admin_section :tournaments
  
  def index
    if params[:tournament_id]
      @tournament = Tournament.from params[:tournament_id]
    else
      tour = Tour.find(params[:tour_id])
      respond_to do |format|
        format.html do
          render :update do |page|
            page.replace_html :matches_grid, :partial => 'tour_matches', :locals => {:tour => tour}
          end
        end
        format.json do
          matches = Match.find(:all, :conditions => {:tour_id => tour.id}, :include => {:competitors => [:team, :stats]}) do
            paginate :page => params[:page], :per_page => params[:rows]
          end
          render :json => matches.to_jqgrid_json([:id, :date, :hosts_name, :guests_name, :score], params[:page], params[:rows], matches.total_entries)
        end
      end
    end
  end
  
  def new
    @tour = Tour.find(params[:tour_id])
    @teams = @tour.league.teams.all(:include => :footballers)
  end
  
  def edit
    @match = Match.find params[:id], :include => {:competitors => [:team, :football_players]}
    @tour = @match.tour
    @teams = @match.tour.league.teams.all(:include => :footballers)
  end
  
  def create
    match_stats = params[:match].delete :stats
    create_events = params[:match].delete(:create_events) != '0'
    params[:match][:tour_id] = params[:tour_id]
    @match = Match.build_from_form params[:match]
    respond_to do |format|
      if @match.save
        logger.info('Match saved')
        @match.update_stats match_stats, create_events
        format.html { redirect_to(admin_tournament_matches_path(Tour.find(params[:tour_id]).league.stage.season.tournament)) }
      else
        logger.info('Match not saved')
        logger.info(@match.errors.to_xml)
        format.html { render :action => "new" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @match.to_ext_json(:success => false) }
      end
    end
  end
  
  def update
    match_stats = params[:match].delete :stats
    params[:match][:played_at] = Date.new(*(1..3).collect{ |i| params[:match].delete("played_at(#{i}i)").to_i })
    create_events = params[:match].delete(:create_events) != '0'
    @match = Match.find params[:id]
    @match.attributes = params[:match]
    respond_to do |format|
      if @match.update_competitors and @match.save
        @match.update_stats match_stats, create_events
        format.html { redirect_to(admin_tournament_matches_path(@match.tour.league.stage.season.tournament)) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
        format.ext_json {render  :json => @match.to_ext_json(:success => false) }
      end
    end
  end
end
