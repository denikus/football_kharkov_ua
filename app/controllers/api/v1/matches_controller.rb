class Api::V1::MatchesController < Api::V1::BaseController
  def show

    # return error if no season with such url
    error!("Incorrect params", 403) and return if params[:id].blank?

    @match = Match.where(:schedule_id => params[:id]).includes(:schedule => :step_tour).first

    response = {
            season_name: @match.schedule.step_tour.stage.season.name,
            tour_name:    @match.schedule.step_tour.name,
            venue_name: @match.schedule.venue.name,
            match_on: @match.schedule.match_on.to_date,
            match_at: @match.schedule.match_at,
            host_team: {
                name: @match.schedule.hosts.name,
                first_period_fouls: @match.hosts.stats.find_by_name('first_period_fouls').value,
                second_period_fouls: @match.hosts.stats.find_by_name('second_period_fouls').value,
                scores: @match.schedule.host_scores,
                players: @match.hosts.football_players.sort_by_number.collect{|player|
                  {
                      number: player.number,
                      first_name: player.footballer.first_name,
                      last_name: player.footballer.last_name
                  }

                }

            },
            guest_team: {
                name: @match.schedule.guests.name,
                first_period_fouls: @match.guests.stats.find_by_name('first_period_fouls').value,
                second_period_fouls: @match.guests.stats.find_by_name('second_period_fouls').value,
                scores: @match.schedule.guest_scores,
                players: @match.guests.football_players.sort_by_number.collect{|player|
                  {
                      number: player.number,
                      first_name: player.footballer.first_name,
                      last_name: player.footballer.last_name
                  }

                }
            },
            events: @match.match_events.collect{|event|
              {
                  minute: event.minute,
                  text: event.message

              }

            }

        }

    respond_to do |format|
      format.json{ render json: response }
    end


  end
end
