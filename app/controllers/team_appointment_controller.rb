# -*- encoding : utf-8 -*-
class TeamAppointmentController < ApplicationController
  def show
    unless params[:id].nil?
      if(user_signed_in?)
        @competitor = Competitor.find(params[:id])

        if @competitor.football_player_appointments.index{|appointment| appointment.footballer.user_id == current_user.id}.nil?
          flash[:error] = "Нет доступа"
          @competitor = nil
        end
      end
    end
  end
end
