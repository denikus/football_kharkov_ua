# -*- encoding : utf-8 -*-
class Admin::TempController < ApplicationController
  before_filter :authenticate_admin!
  
  layout "admin/temp"
  
  def index
    cookies[:schedule_tournament_id] ||= 2


    @tournaments = Tournament.all

    @season = StepSeason.where("tournament_id = ?", cookies[:schedule_tournament_id]).order("created_at ASC").last

    @stage = @season.stages.last

    @tours = StepTour.joins("INNER JOIN steps_phases AS s_p ON (steps.id=s_p.phase_id)").where("steps.tournament_id = ? AND s_p.step_id=?", cookies[:schedule_tournament_id], @stage.id).order("created_at ASC")


    #@tours = StepTour.find(:all,
    #                       :conditions => ["tournament_id = ? ", cookies[:schedule_tournament_id]],
    #                       :order => "identifier ASC"
    #                      )
    @venues = Venue.all
    @schedule = Schedule.new({:match_on => "2012-05-"})
    
    @last_schedules = Schedule.joins("INNER JOIN steps ON (steps.id = schedules.tour_id AND steps.type = 'StepTour')").
                               where("tournament_id = ? ", cookies[:schedule_tournament_id]).
                               order("match_on DESC, venue_id ASC, match_at ASC").
                               limit(120)

    #@last_schedules = Schedule.find(
    #                                :all,
    #                                :joins => "INNER JOIN steps ON (steps.id = schedules.tour_id AND steps.type = 'StepTour')",
    #                                :conditions => ["tournament_id = ? ", cookies[:schedule_tournament_id]],
    #                                :order => "match_on DESC, venue_id ASC, match_at ASC",
    #                                :limit => 80
    #                               )
  end

  def delete_schedule
    unless params[:id].nil?
      Match.delete_all(["schedule_id = ? ", params[:id]])
      Schedule.delete(params[:id])
    end
    redirect_to :action => "index"
  end

  def edit_schedule
    @schedule = Schedule.find(params[:id])
    @venues = Venue.all
  end

  def update_schedule
    @schedule = Schedule.find(params[:schedule][:id])
    @schedule.update_attributes(params[:schedule])

    redirect_to action: 'edit_schedule', id: params[:schedule][:id]
  end

  def get_tours

    if params["tournament_id"].nil?
      return false
    end

    last_season = StepSeason.by_tournament(params["tournament_id"]).last
    
    cookies[:schedule_tournament_id] = params["tournament_id"]

    @tours = StepTour.joins("INNER JOIN steps_phases ON (phase_id = steps.id) ").where("steps_phases.step_id IN (#{last_season.stages.collect!{|x| x.id}.join(',')})").order("identifier ASC")
    data = @tours.collect do |tour|
      {:text => tour.name,
       :value => tour.id
      }
    end

    render :layout => false, :json => data.to_json.html_safe
  end

  def teams
    if (params[:search_type]=="host")
      @teams = Team.find(:all,
                         :conditions => ["name LIKE ?", "#{params[:search][:term]}%"]
                        )
    else
      stage = StepStage.find(:first,
                             :joins => "INNER JOIN steps_phases ON (steps_phases.step_id = steps.id AND steps.type='StepStage')",
                             :conditions => ["steps_phases.phase_id = ? ", params[:tour_id]]
                            )

      league = StepLeague.find(:first,
                               :joins => "INNER JOIN steps_teams ON (steps_teams.step_id = steps.id AND steps.type='StepLeague') " +
                                         "INNER JOIN steps_phases ON (steps_phases.phase_id=steps.id)",
                               :conditions => ["steps_teams.team_id = ? AND steps_phases.step_id = ?", params[:host_team_id], stage.id]
                              )

      @teams = Team.find(:all,
                        :joins => "INNER JOIN steps_teams ON (steps_teams.team_id = teams.id)",
                        :conditions => ["teams.id != ? AND steps_teams.step_id = ? AND teams.name LIKE ?", params[:host_team_id], league.id, "#{params[:search][:term]}%"]
                       )
    end

    data = @teams.collect do |c|
      label = c.name
      { :label => label,
        :value => label,
        :id => c.id
      }
    end

    render :layout => false, :json => data.to_json.html_safe
  end

  def create

    stage = StepStage.find(:first,
                             :joins => "INNER JOIN steps_phases ON (steps_phases.step_id = steps.id AND steps.type='StepStage')",
                             :conditions => ["steps_phases.phase_id = ? ", params[:schedule][:tour_id]]
                            )

    league = StepLeague.find(:first,
                             :joins => "INNER JOIN steps_teams ON (steps_teams.step_id = steps.id AND steps.type='StepLeague') " +
                                       "INNER JOIN steps_phases ON (steps_phases.phase_id=steps.id)",
                             :conditions => ["steps_teams.team_id = ? AND steps_phases.step_id = ?", params[:schedule][:host_team_id], stage.id]
                            )
    unless league.nil?
      params[:schedule].merge!({:league_id => league.id})
      Schedule.create(params[:schedule])
    end  

    redirect_to :controller => "temp", :action => "index"
  end

  def import_from_csv

    params[:upload]['datafile'].read.to_s.each_line do |params_line|

      schedule_params = params_line.split(",")

      Schedule.create(
          :tour_id       => params[:schedule][:tour_id],
          :host_team_id  => Team.find_by_name(schedule_params[0]).id,
          :guest_team_id => Team.find_by_name(schedule_params[1]).id,
          :venue_id      => Venue.find_by_name(schedule_params[2]).id,
          :match_on      => schedule_params[3],
          :match_at      => schedule_params[4])
    end

    redirect_to :controller => "temp", :action => "index"
  end
end
