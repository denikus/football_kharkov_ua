# -*- encoding : utf-8 -*-
class Admin::QuickMatchResultsController < ApplicationController
  layout 'admin/main'

#  admin_section :tournaments

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
          @schedules = Schedule.all(:conditions => ['season_id = ? AND match_on = ?', params[:season_id], params[:match_on]], :include => [:venue, :hosts, :guests])
          locals = {:match_on => params[:match_on]}
=begin
locals = {:venues => Venue.all.collect{ |v| [v.name, v.id] },
                    :teams => season.teams.find(:all, :order => "name ASC").collect{ |t| [t.name, t.id] },
                    :schedules => schedules
                    }
=end
          render :update do |page|
            page.replace_html :schedules, :partial => 'match_result_block', :object => @schedules, :locals => locals
          end
        else
          render :update do |page|
            page.replace_html :schedule_guest_team_id, :partial => 'schedule_date', :collection => season.schedule_dates
          end
        end
      end
    end
  end

  def update_all
    params[:schedule].each_pair do |key, value|

      schedule_record = Schedule.find(key)
      result_params = nil
      if !value[:hosts_score].empty? && !value[:guests_score].empty?
        result_params = {:hosts_score => value[:hosts_score], :guests_score => value[:guests_score]}
      end
      
      unless result_params.nil?
        if schedule_record.quick_match_result.nil?
          schedule_record.create_quick_match_result(result_params)
        else
          schedule_record.quick_match_result.update_attributes(result_params)
        end
      end  
    end

    redirect_to :action => "index"
  end
  

end
