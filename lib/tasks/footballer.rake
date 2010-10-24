namespace :footballer do
  desc "Import footballers from txt file and link to teams and seasons"
  task :import, [:season_id] => :environment do |t, args|
    unless args.season_id.nil?
      season_id = args.season_id.to_i

      fh = File.open("#{RAILS_ROOT}/lib/footballers.txt", "r")
      fh.readlines.each do |line|
        team_footballers = line.split(';')
        team_name = team_footballers.delete_at(0)
        if team_name == 'Галерея'
          team_name = "Галерея-Атомстайл"
        elsif team_name == 'Рост'
          team_name = "Рост и Ветераны"
        end

        #search team by name and season
        team = Team.find(:first, :joins => "INNER JOIN seasons_teams ON (teams.id = seasons_teams.team_id)", :conditions => ["teams.name = ? AND season_id = ? ", team_name.strip, season_id] )

        #if team not exists
        if team.nil?
          puts "Team \"#{team_name}\" not found!"
        end

        team_footballers.each do |footballer|
          #check if footballer exists
          footballer_name = footballer.split(' ')
          if Footballer.find(:first, :conditions => ["last_name = ? AND first_name = ?", footballer_name[0].strip, footballer_name[1].strip]).nil?
            new_footballer = Footballer.create({:last_name => footballer_name[0].strip, :first_name => footballer_name[1].strip})
            if !new_footballer.nil? && !team.nil?
              new_footballer_team = new_footballer.footballers_teams.create({:season_id => season_id, :team_id => team.id})
            end
          else
#            puts'================'
#            puts "#{footballer_name[0].strip} #{footballer_name[1].strip}"
#            puts'================'
          end
        end
      end
    end

  end


end