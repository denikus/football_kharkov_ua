class FootballPlayerAppointmentController < ApplicationController
  def update
    if user_signed_in?
      @appointment = FootballPlayerAppointment.find(params[:id])

      if(@appointment.footballer.user_id == current_user.id)
        @appointment.response = params[:appointment_response]
        @appointment.update_attributes(params[:appointment])

        redirect_to footballer_path(@appointment.footballer.url)
      end
    end
  end
end