namespace :integrate do
  desc "copy uid for team"
  task :teams_uid => :environment do

    response = HTTParty.get(URI.escape("https://onetwoteam.com/api/v1/teams/tournament/itleague.json"))

    @teams = response["data"]

    @teams.each do |item|
      teams = Team.where(name: item["name"])

      puts "more than 1 team found" and next if teams.length > 1

      teams.first.update_attribute(:ott_uid, item["id"])
    end


    # counter = 0
    # Comment.find_each do |comment|
    #   comment.prepare_data
    #   comment.save
    #   counter += 1
    #
    #   puts "Processed: #{counter} from #{Comment.count}" if (counter%100) == 0
    # end
  end
end