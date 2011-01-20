require 'csv'
namespace :migrate do
  desc "Import matches - create schedules for them"
  task :matches_without_schedule => :environment do
    match_id = 0
    schedule_counter = 0
    schedule_params = []
    CSV.open("#{RAILS_ROOT}/lib/migration/data/matches.csv", 'r', ';') do |row|
      #row values:
      #0match_id 	1tour_id 	2referee_id 	3match_type 	4played_at 	5period_duration 	6comment 	7created_at 	8updated_at 	9side 	10team_id 	11value

      if match_id != row[0]
        #venue_id 	match_on 	match_at 	host_team_id 	guest_team_id 	created_at 	updated_at 	league_id 	tour_id 	host_scores 	guest_scores

        match_on, match_at = row[4].split(' ')

        schedule_params[schedule_counter] = {:venue_id => nil,
                           :host_team_id => (row[9]=='hosts' ? row[10] : nil),
                           :guest_team_id => (row[9]=='guests' ? row[10] : nil),
                           :host_scores => (row[9]=='hosts' ? row[11] : nil),
                           :guest_scores => (row[9]=='guests' ? row[11] : nil),
                           :tour_id => nil,
                           :match_on => match_on,
                           :match_at => match_at,
                           :match_id => row[0]
                           }

      #if match not exists yet  
      else
        if schedule_params[schedule_counter][:host_team_id].nil?
          schedule_params[schedule_counter][:host_team_id] = row[10]
          schedule_params[schedule_counter][:host_scores] = row[11]
        else
          schedule_params[schedule_counter][:guest_team_id] = row[10]
          schedule_params[schedule_counter][:guest_scores] = row[11]
        end
        schedule_counter += 1
      end
      match_id = row[0]
    end
    
    schedule_params.each do |item|
      match_id = item.delete(:match_id)
      if match_id!=0
        match = Match.find(match_id)
        match.create_schedule(item)
        match.save
      end  
    end
  end

  desc "Import schedules and quick results from old scheme - and create new schedules and matches"
  task :schedules => :environment do
    CSV.open("#{RAILS_ROOT}/lib/migration/data/schedules_old.csv", 'r', ';') do |row|
      #row values:
      #0id	1venue_id	2match_on	3match_at	4host_team_id	5guest_team_id	6created_at	7updated_at	8hosts_score	9guests_score
      schedule_params = {
                         :id => row[0],
                         :venue_id => row[2],
                         :host_team_id => row[5],
                         :guest_team_id => row[6],
                         :host_scores => nil,
                         :guest_scores => nil,
                         :tour_id => nil,
                         :match_on => row[3],
                         :match_at => row[4],
                         :created_at => row[7],
                         :updated_at => row[8]
                        }

      Schedule.create(schedule_params)
    end  
  end

  desc "Import quick results to new scheme"
  task :univer_quick_results => :environment do
    #row[2], row[3]
    CSV.open("#{RAILS_ROOT}/lib/migration/data/quick_results.csv", 'r', ';') do |row_string|
      row = row_string[0].split(',')
      schedule = Schedule.find(:first,
                               :conditions => ["host_team_id = ? AND guest_team_id = ?  AND league_id IS NULL AND match_on>='2010-12-18'", row[0], row[1]]
      )

      #

      unless schedule.nil?
#        puts "#{schedule.hosts.name} #{schedule.host_scores} - #{schedule.guest_scores} #{schedule.guests.name}"
        if schedule.league_id.nil?
            host_league = Team.find(:first,
                                   :select => "teams.name AS team_name, steps.name AS league_name, steps.id AS league_id",
                                   :joins =>  "INNER JOIN steps_teams " +
                                               "ON (teams.id = steps_teams.team_id) " +
                                             "INNER JOIN steps " +
                                               "ON (steps_teams.step_id = steps.id AND steps.type = 'StepLeague')",
                                   :conditions => ["teams.id = ? AND steps.id >14 AND steps.id<27 ", schedule.hosts.id]
                                   )
            guest_league = Team.find(:first,
                                   :select => "teams.name AS team_name, steps.name AS league_name, steps.id AS league_id",
                                   :joins =>  "INNER JOIN steps_teams " +
                                               "ON (teams.id = steps_teams.team_id) " +
                                             "INNER JOIN steps " +
                                               "ON (steps_teams.step_id = steps.id AND steps.type = 'StepLeague')",
                                   :conditions => ["teams.id = ? AND steps.id >14 AND steps.id<27", schedule.guests.id]
                                   )

          schedule.league_id = host_league[:league_id]
          schedule.host_scores = row[2]
          schedule.guest_scores = row[3]
          schedule.save!

#          if host_league.nil?
#            puts "nil host_team_id: #{schedule.hosts.id} - schedule_id => #{schedule.id}"
#            puts "nil guest_team_id: #{schedule.guests.id} - schedule_id => #{schedule.id}"
#          else
#            puts "#{host_league[:league_name]} - #{host_league[:league_id]} - #{host_league[:team_name]}"
#            puts "#{guest_league[:league_name]} - #{guest_league[:league_id]} - #{guest_league[:team_name]}"
#            puts "----------------------"
#          end
        end
      end
    end
  end

end