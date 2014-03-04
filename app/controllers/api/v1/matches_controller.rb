# -*- encoding : utf-8 -*-
class Api::V1::MatchesController < Api::V1::BaseController
  def show

    # return error if no season with such url
    error!("Incorrect params", 403) and return if params[:id].blank?

    @match = Match.where(:schedule_id => params[:id]).includes(:schedule => :step_tour).first

    @events = []

    #hosts
    @match.hosts.football_players.sort_by_number.each do |player|
      player.stats.each do |stat|
        @events << {minute: stat.value,
                    player_name: "#{player.footballer.first_name} #{player.footballer.last_name}",
                    player_number: player.number,
                    statistic_type: stat.name,
                    team: "host_team"
                   }
      end
    end

    #guests
    @match.guests.football_players.sort_by_number.each do |player|
      player.stats.each do |stat|
        @events << {minute: stat.value,
                    player_name: "#{player.footballer.first_name} #{player.footballer.last_name}",
                    player_number: player.number,
                    statistic_type: stat.name,
                    team: "guest_team"
                   }
      end
    end

    #ap @events
    @events.sort! { |a,b| a[:minute] <=> b[:minute] }
    #ap @events



    response = {
            season_name: @match.schedule.step_tour.stage.season.name,
            tour_name:    @match.schedule.step_tour.name,
            venue_name: @match.schedule.venue.name,
            match_on: @match.schedule.match_on.to_date,
            match_at: @match.schedule.match_at,
            host_team: {
                name: @match.schedule.hosts.name,
                first_period_fouls:  (@match.hosts.stats.find_by_name('first_period_fouls') ? @match.hosts.stats.find_by_name('first_period_fouls').value : 0),
                second_period_fouls: (@match.hosts.stats.find_by_name('second_period_fouls') ? @match.hosts.stats.find_by_name('second_period_fouls').value : 0),
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
                first_period_fouls: (@match.guests.stats.find_by_name('first_period_fouls') ? @match.guests.stats.find_by_name('first_period_fouls').value : 0),
                second_period_fouls: (@match.guests.stats.find_by_name('second_period_fouls') ? @match.guests.stats.find_by_name('second_period_fouls').value : 0),
                scores: @match.schedule.guest_scores,
                players: @match.guests.football_players.sort_by_number.collect{|player|
                  {
                      number: player.number,
                      first_name: player.footballer.first_name,
                      last_name: player.footballer.last_name
                  }

                }
            },
            events: @events,
              #  @match.match_events.collect{|event|
              #{
              #    minute: event.minute,
              #    text: event.message
              #
              #}

            #},
            referees: @match.referees.collect{|referee|
              {first_name: referee.first_name,
               last_name: referee.last_name
              }
            }

        }

    if params[:id] == 4046
      response = {
          season_name: "Nano",
          tour_name: "13",
          venue_name: "Площадка ХИРЭ",
          match_on: "2014-10-10",
          match_at: "12:00",
          host_team: {
              name: "Zfort Group",
              first_period_fouls: 0,
              second_period_fouls: 0,
              scores: 1,
              players: []
          },
          guest_team: {
              name: "GraceHoppers",
              first_period_fouls: 0,
              second_period_fouls: 0,
              scores: 0,
              players: []
          },
          events: [],
          referees: []
      }
    elsif params[:id] == 4047
           response = {
               season_name: "Nano",
               tour_name: "13",
               venue_name: "Площадка ХИРЭ",
               match_on: "2014-11-11",
               match_at: "12:00",
               host_team: {
                   name: "GraceHoppers",
                   first_period_fouls: 0,
                   second_period_fouls: 0,
                   scores: 1,
                   players: []
               },
               guest_team: {
                   name: "Zfort Group",
                   first_period_fouls: 0,
                   second_period_fouls: 0,
                   scores: 0,
                   players: []
               },
               events: [],
               referees: []
           }

    end

    respond_to do |format|
      format.json{ render json: response }
    end


  end
end
