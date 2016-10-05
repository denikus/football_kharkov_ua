namespace :comments do
  desc "copy comments"
  task :process => :environment do
    counter = 0
    Comment.find_each do |comment|
      comment.prepare_data
      comment.save
      counter += 1

      puts "Processed: #{counter} from #{Comment.count}" if (counter%100) == 0
    end
  end
end