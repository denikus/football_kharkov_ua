# -*- encoding : utf-8 -*-
class Api::V1::Schedules::TeamsController < Api::V1::BaseController
  before_filter :find_tournament
  before_filter :find_team

  def show
    # get all incoming matches
    @schedule = Schedule.where("(host_team_id = ? OR  guest_team_id = ?) AND match_on > ?",
                              @team.id, @team.id, Time.zone.now.beginning_of_day)
                       .includes(:venue, :hosts, :guests)

    render json: @schedule, each_serializer: TeamScheduleSerializer, team: @team, root: 'data'
  end

end
