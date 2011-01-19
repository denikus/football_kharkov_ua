class Admin::SchedulesController < ApplicationController
  layout 'admin/main'
  
  def index
    respond_to do |format|
      format.html do
        @tournament = Tournament.from params[:tournament_id]
        @seasons = @tournament.seasons
        @venues = Venue.all
      end
      format.js do
        season = Season.find params[:season_id]
        unless params[:match_on].nil?
          schedules = Schedule.all(:conditions => ['season_id = ? AND match_on = ?', params[:season_id], params[:match_on]], :include => [:venue, :hosts, :guests])
          locals = {:venues => Venue.all.collect{ |v| [v.name, v.id] }, :teams => season.teams.find(:all, :order => "name ASC").collect{ |t| [t.name, t.id] }}
          render :update do |page|
            page.replace_html :schedules, :partial => 'schedule', :collection => schedules, :locals => locals
            page.replace_html :new_sched, :partial => 'schedule', :object => Schedule.new(:season_id => params[:season_id], :match_on => params[:match_on]), :locals => locals
          end
        else
          render :update do |page|
            page.replace_html :schedule_guest_team_id, :partial => 'schedule_date', :collection => season.schedule_dates
          end
        end
      end
    end
  end
  
  def create
#    season = Season.find params[:schedule][:season_id]
    tour   = Tour.find(params[:schedule][:tour_id])
    season = tour.stage.season
    
    schedule = Schedule.new params[:schedule]
    schedule.save
#    ap schedule
#    debugger
    locals = {:venues => Venue.all.collect{ |v| [v.name, v.id] }, :teams => season.teams.find(:all, :order => "name ASC").collect{ |t| [t.name, t.id] }}
    render :update do |page|
      page.replace_html :schedule_date, :partial => 'schedule_date', :collection => season.schedule_dates
      page.insert_html :append, 'schedules', :partial => 'schedule', :object => schedule, :locals => locals
      page << "$('#new_schedule').wrap('<div id=\"new_schedule_holder\">')"
      page.replace_html "new_schedule_holder", :partial => 'schedule', :object => Schedule.new(:tour => tour, :match_on => params[:schedule][:match_on]), :locals => locals
      page << "$('#new_schedule').unwrap()"
    end
  end
  
  def update
    schedule = Schedule.find params[:id]
    season = Season.find params[:schedule][:season_id]
    locals = {:venues => Venue.all.collect{ |v| [v.name, v.id] }, :teams => season.teams.collect{ |t| [t.name, t.id] }}
    schedule.update_attributes params[:schedule]
    render :update do |page|
      page << "$('#edit_schedule_#{schedule.id}').wrap('<div id=\"schedule_#{schedule.id}_holder\">')"
      page.replace_html "schedule_#{schedule.id}_holder", :partial => 'schedule', :object => schedule, :locals => locals
      page << "$('#edit_schedule_#{schedule.id}').unwrap()"
    end
  end
  
  def destroy
    Schedule.find(params[:id]).destroy
    
    render :update do |page|
      page["edit_schedule_#{params[:id]}"].remove
    end
  end
  
  def results
    schedule = Schedule.find(params[:id], :include => {:match => {:competitors => [:stats, {:football_players => :stats}]}})
    
    render :json => {
      :success => true,
      :data => {
        'hosts[score]' => schedule.match.hosts.stats.get('score') || 0,
        'hosts[first_period_fouls]' => schedule.match.hosts.stats.get('first_period_fouls') || 0,
        'hosts[second_period_fouls]' => schedule.match.hosts.stats.get('second_period_fouls') || 0,
        'guests[score]' => schedule.match.guests.stats.get('score') || 0,
        'guests[first_period_fouls]' => schedule.match.guests.stats.get('first_period_fouls') || 0,
        'guests[second_period_fouls]' => schedule.match.guests.stats.get('second_period_fouls') || 0,
      }
    }
  end
  
  def update_results
    schedule = Schedule.find(params[:id], :include => {:match => {:competitors => [:stats, {:football_players => :stats}]}})
    
    %w{hosts guests}.each do |side|
      Competitor::STATS.each do |stat|
        schedule.match.competitors[side].stats.set(stat, params[side][stat])
      end
      schedule[side.singularize + '_scores'] = params[side]['score']
    end
    
    schedule.save
    
    render ext_success
  end
  
  def week
    render ext_success
  end
end
