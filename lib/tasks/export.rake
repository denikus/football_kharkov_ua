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

  task venues: :environment do
    CSV.open('db/export/venues.csv', 'w') do |csv|
      csv << %w{id name short_name url icon created_at updated_at page_content page_title}

      # create export csv
      Venue.find_each do |item|
        csv << [item.id, item.name, item.short_name, item.url, item.icon, item.created_at, item.updated_at, item.page_content, item.page_title]
      end
    end
  end

  task steps_phases: :environment do
    items = ActiveRecord::Base.connection.execute('SELECT * FROM steps_phases')

    CSV.open('db/export/steps_phases.csv', 'w') do |csv|
      csv << %w{step_id phase_id}

      # create export csv
      items.each do |item|
        csv << [item["step_id"], item["phase_id"]]
      end
    end
  end

  task steps_teams: :environment do
    items = ActiveRecord::Base.connection.execute('SELECT * FROM steps_teams')

    CSV.open('db/export/steps_teams.csv', 'w') do |csv|
      csv << %w{step_id team_id}

      # create export csv
      items.each do |item|
        csv << [item["step_id"], item["team_id"]]
      end
    end
  end

  task schedules: :environment do
    CSV.open('db/export/schedules.csv', 'w') do |csv|
      csv << %w{id venue_id match_on match_at host_team_id guest_team_id created_at updated_at host_scores guest_scores league_id tour_id}

      # create export csv
      Schedule.find_each do |item|

        next if item.league_id.blank?

        league = StepLeague.find(item.league_id)
        if league.stage.season.tournament_id == 1
          csv << [item.id, item.venue_id, item.match_on, item.match_at, item.host_team_id, item.guest_team_id, item.created_at, item.updated_at, item.host_scores, item.guest_scores, item.league_id, item.tour_id]
        end
      end
    end
  end

  task referees: :environment do
    CSV.open('db/export/referees.csv', 'w') do |csv|

      csv << %w{id user_id first_name last_name patronymic birth_date created_at updated_at}

      # create export csv
      Referee.find_each do |item|
        csv << [item.id, item.user_id, item.first_name, item.last_name, item.patronymic, item.birth_date, item.created_at, item.updated_at]
      end
    end
  end


  task step_properties: :environment do
    CSV.open('db/export/step_properties.csv', 'w') do |csv|
      csv << %w{id step_id property_name property_value}

      # create export csv
      StepProperty.find_each do |item|
        csv << [item.id, item.step_id, item.property_name, item.property_value]
      end
    end
  end


  task matches: :environment do
    CSV.open('db/export/matches.csv', 'w') do |csv|
      csv << %w{id created_at updated_at schedule_id}


      Match.find_each do |item|

        next if item.schedule.league_id.blank?

        league = StepLeague.find(item.schedule.league_id)

        if league.stage.season.tournament_id == 1
          csv << [item.id, item.created_at, item.updated_at, item.schedule_id]
        end
      end

    end
  end

  task matches_referees: :environment do
    items = ActiveRecord::Base.connection.execute('SELECT * FROM matches_referees')

    CSV.open('db/export/matches_referees.csv', 'w') do |csv|
      csv << %w{match_id referee_id}

      # create export csv
      items.each do |item|
        csv << [item["match_id"], item["referee_id"]]
      end
    end
  end

  task competitors: :environment do
    CSV.open('db/export/competitors.csv', 'w') do |csv|
      csv << %w{id match_id side team_id score fouls}

      # create export csv
      Competitor.find_each do |item|
        csv << [item.id, item.match_id, item.side, item.team_id, item.score, item.fouls]
      end
    end
  end

  task footballer: :environment do
    CSV.open('db/export/footballers.csv', 'w') do |csv|
      csv << %w{id first_name last_name patronymic birth_date created_at updated_at url ott_player_id ott_uid ott_path}

      # create export csv
      Footballer.find_each do |item|
        csv << [item.id, item.first_name, item.last_name, item.patronymic, item.birth_date, item.created_at, item.updated_at, item.url, item.ott_player_id, item.ott_uid, item.ott_path]
      end
    end
  end

  task football_players: :environment do
    CSV.open('db/export/footballer_players.csv', 'w') do |csv|
      csv << %w{id competitor_id footballer_id number}

      # create export csv
      FootballPlayer.find_each do |item|
        csv << [item.id, item.competitor_id, item.footballer_id, item.number]
      end
    end
  end

  task footballers_teams: :environment do
    CSV.open('db/export/footballers_teams.csv', 'w') do |csv|
      csv << %w{footballer_id team_id step_id}

      # create export csv
      FootballersTeam.order("footballers_teams.footballer_id").find_each do |item|
        csv << [item.footballer_id, item.team_id, item.step_id]
      end
    end
  end



end