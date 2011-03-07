class Admin::TempController < ApplicationController
  before_filter :authenticate_admin!
  
  layout "admin/temp"
  
  def index
    @tours = StepTour.find(:all,
                           :conditions => ["tournament_id = ? ", 2],
                           :order => "identifier ASC"
                          )
    @venues = Venue.all
    @schedule = Schedule.new({:match_on => "2011-01-"})
    
    @last_schedules = Schedule.find(
                                    :all,
                                    :joins => "INNER JOIN steps ON (steps.id = schedules.tour_id AND steps.type = 'StepTour')",
                                    :conditions => ["tournament_id = ? ", 2],
                                    :order => "match_on DESC, venue_id ASC, match_at ASC",
                                    :limit => 80
                                   )
  end

  def delete_schedule
    unless params[:id].nil?
      Match.delete_all(["schedule_id = ? ", params[:id]])
      Schedule.delete(params[:id])
    end
    redirect_to :action => "index"
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
