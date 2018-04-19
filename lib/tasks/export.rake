namespace :export do
  desc 'export blog'
  task blog: :environment do

    # create csv file
    CSV.open('posts.csv', 'w') do |csv|

      # form file headings
      csv << %w{id author_id url title body tournament_id  created_at}

      # Select All posts
      Article.find_each do |article|
        next if article.post.blank? || article.post.tournament_id != 1
        csv << [article.post.id, article.post.author_id, article.post.url, article.post.title, article.body, article.post.tournament_id, article.post.created_at]
      end
    end
  end

  task users: :environment do
    # create csv file
    CSV.open('users.csv', 'w') do |csv|

      # form file headings
      csv << %w{id username email enabled created_at updated_at encrypted_password password_salt confirmation_token
                confirmed_at confirmation_sent_at reset_password_token remember_created_at sign_in_count current_sign_in_at
                last_sign_in_at current_sign_in_ip last_sign_in_ip unconfirmed_email reset_password_sent_at }

      # Select All posts
      User.find_each do |user|
        csv << [user.id, user.username, user.email, user.enabled, user.created_at, user.updated_at, user.encrypted_password, user.password_salt, user.confirmation_token,
        user.confirmed_at, user.confirmation_sent_at, user.reset_password_token, user.remember_created_at, user.sign_in_count, user.current_sign_in_at,
        user.last_sign_in_at, user.current_sign_in_ip, user.last_sign_in_ip, user.unconfirmed_email, user.reset_password_sent_at]
      end
    end
  end

  task steps: :environment do

    CSV.open('db/export/steps.csv', 'w') do |csv|

      csv << %w{id type tournament_id identifier name url created_at updated_at short_name}

      # create export csv
      Step.where(tournament_id: 1).find_each do |item|
        csv << [item.id, item.type, item.tournament_id, item.identifier, item.name, item.url, item.created_at, item.updated_at, item.short_name]
      end
    end
  end

  task teams: :environment do
    CSV.open('db/export/teams.csv', 'w') do |csv|
      csv << %w{id name url created_at updated_at ott_uid ott_path}

      # create export csv
      Team.find_each do |item|
        csv << [item.id, item.name, item.url, item.created_at, item.updated_at, item.ott_uid, item.ott_path]
      end
    end
  end
end