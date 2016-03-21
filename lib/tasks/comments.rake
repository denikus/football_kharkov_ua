namespace :comments do
  desc "copy products from lazada provider (by category) and link themself as connected"
  # get all products by category, save only path and add to proper category
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