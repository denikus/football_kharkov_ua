namespace :export do
  desc 'export blog'
  task blog: :environment do

    # create csv file
    CSV.open("posts.csv", "w") do |csv|

      # form file headings
      csv << %w{author_id url title tournament_id body created_at}

      # Select All posts
      Article.find_each do |article|
        next if article.post.blank? || article.post.tournament_id != 1
        csv << [article.post.id, article.post.url, article.post.title, article.body, article.post.tournament_id, article.post.created_at]
      end
    end
  end
end