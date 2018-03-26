# -*- encoding : utf-8 -*-
class TeamsController < ApplicationController
  layout "app_without_sidebar"
  
  def index
    unless request.subdomain.nil?
      tournament = Tournament.find_by_url(request.subdomain)
      last_season = StepSeason.where(:tournament_id => tournament.id).order("created_at ASC").last

      @teams_by_groups = []
      last_season.stages.first.leagues.order("identifier ASC").each do |league|
        @teams_by_groups << {:league_name  => league.name, :teams => league.teams}
      end
    end
  end

  def show
    unless request.subdomain.blank?
      @team = Team.find_by_url(params[:id])
      if @team.nil?
        render "#{Rails.root}/public/404.html", :status => 404, :layout => false
        return
      end

      @tournament = Tournament.find_by_url(request.subdomain)
      @season = StepSeason.joins("INNER JOIN steps_teams ON (steps.id = steps_teams.step_id) ").
                      where("steps_teams.team_id = ? AND steps.tournament_id = ? ", @team.id, @tournament.id).
                      order("created_at ASC").last
      #@season = StepSeason.find(:last,
      #                           :joins => "INNER JOIN steps_teams ON (steps.id = steps_teams.step_id) ",
      #                           :conditions => ["steps_teams.team_id = ? AND steps.tournament_id = ? ", @team.id, @tournament.id]
      #                          )
#      @team.seasons.by_tournament(@tournament.id)
      unless @season.nil?
        @footballers = Footballer.by_team_step({:team_id => @team.id, :step_id => @season.id} )
      end
      @schedules = Schedule.future_team_matches(@team.id)
    else
      render "#{Rails.root}/public/404.html", :status => 404, :layout => false
      return
    end
  end
end
