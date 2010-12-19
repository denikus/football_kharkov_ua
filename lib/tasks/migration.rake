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
    CSV.open("#{RAILS_ROOT}/lib/migration/data/schedules.csv", 'r', ';') do |row|
      #row values:
      #0id	1venue_id	2match_on	3match_at	4host_team_id	5guest_team_id	6created_at	7updated_at	8hosts_score	9guests_score
      schedule_params = {
                         :id => row[0],
                         :venue_id => row[1],
                         :host_team_id => row[4],
                         :guest_team_id => row[5],
                         :host_scores => row[8],
                         :guest_scores => row[9],
                         :tour_id => nil,
                         :match_on => row[2],
                         :match_at => row[3],
                         :created_at => row[6],
                         :updated_at => row[7]
                        }
      Schedule.create(schedule_params)
    end  
  end

end