require 'csv'
namespace :migrate do
  desc "Import footballers from txt file and link to teams and seasons"
  task :matches_without_schedule => :environment do
#    require 'csv'
    match_id = 0
    schedule_counter = 0
    schedule_params = []
    CSV.open("#{RAILS_ROOT}/lib/migration/data/matches.csv", 'r', ';') do |row|
      #create new schedule record if not exists
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
                           :match_at => match_at            
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
      schedule = Schedule.new(item)
      schedule.save!
    end

  end
end