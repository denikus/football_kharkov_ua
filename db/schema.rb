# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110526173626) do

  create_table "admins", :force => true do |t|
    t.string   "full_name",           :limit => 64,                     :null => false
    t.boolean  "super_admin",                        :default => false, :null => false
    t.string   "email",               :limit => 100,                    :null => false
    t.string   "encrypted_password",  :limit => 40,                     :null => false
    t.string   "password_salt",       :limit => 20,                     :null => false
    t.string   "remember_token",      :limit => 20
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_images", :force => true do |t|
    t.integer "article_id"
    t.string  "file"
    t.string  "title"
  end

  add_index "article_images", ["article_id"], :name => "article_id"

  create_table "articles", :force => true do |t|
    t.text "body"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                                 :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 25
    t.string   "guid",              :limit => 10
    t.integer  "locale",            :limit => 1,  :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "fk_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_assetable_type"
  add_index "ckeditor_assets", ["user_id"], :name => "fk_user"

  create_table "comments", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "lft",        :null => false
    t.integer  "rgt",        :null => false
    t.integer  "post_id"
    t.integer  "author_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["author_id"], :name => "fk_user_comment"
  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["post_id"], :name => "post_id"

  create_table "competitors", :force => true do |t|
    t.integer "match_id",                                                  :null => false
    t.enum    "side",     :limit => [:hosts, :guests], :default => :hosts, :null => false
    t.integer "team_id",                                                   :null => false
    t.integer "score",    :limit => 2,                 :default => 0,      :null => false
    t.integer "fouls",    :limit => 2,                 :default => 0,      :null => false
  end

  add_index "competitors", ["match_id"], :name => "index_competitors_on_match_id"
  add_index "competitors", ["team_id"], :name => "index_competitors_on_team_id"

  create_table "contents", :force => true do |t|
    t.string   "title",      :null => false
    t.text     "body"
    t.string   "type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["author_id"], :name => "author_id"

  create_table "football_player_appointments", :force => true do |t|
    t.integer "competitor_id"
    t.integer "footballer_id"
    t.enum    "response",      :limit => [:not_responded, :accepted, :declined, :tentative], :default => :not_responded, :null => false
  end

  create_table "football_players", :force => true do |t|
    t.integer "competitor_id",              :null => false
    t.integer "footballer_id",              :null => false
    t.integer "number",        :limit => 2, :null => false
  end

  add_index "football_players", ["competitor_id"], :name => "index_football_players_on_competitor_id"
  add_index "football_players", ["footballer_id"], :name => "index_football_players_on_footballer_id"

  create_table "footballers", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name",         :null => false
    t.string   "last_name",          :null => false
    t.string   "patronymic"
    t.date     "birth_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "crop_x_left"
    t.integer  "crop_y_top"
    t.integer  "crop_width"
    t.integer  "crop_height"
  end

  add_index "footballers", ["user_id"], :name => "user_id"

  create_table "footballers_teams", :id => false, :force => true do |t|
    t.integer "footballer_id"
    t.integer "team_id"
    t.integer "step_id"
  end

  add_index "footballers_teams", ["footballer_id"], :name => "index_footballers_teams_on_footballer_id"
  add_index "footballers_teams", ["step_id"], :name => "index_footballers_teams_on_season_id"
  add_index "footballers_teams", ["team_id"], :name => "index_footballers_teams_on_team_id"

  create_table "leagues", :force => true do |t|
    t.integer  "stage_id",   :null => false
    t.string   "name",       :null => false
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "leagues", ["stage_id"], :name => "stage_id"

  create_table "leagues_teams", :id => false, :force => true do |t|
    t.integer "league_id"
    t.integer "team_id"
  end

  add_index "leagues_teams", ["league_id"], :name => "league_id"
  add_index "leagues_teams", ["team_id"], :name => "team_id"

  create_table "match_event_types", :force => true do |t|
    t.string "symbol"
    t.string "template"
  end

  create_table "match_events", :force => true do |t|
    t.integer "match_id"
    t.integer "match_event_type_id"
    t.integer "minute"
    t.string  "message"
  end

  add_index "match_events", ["match_event_type_id"], :name => "index_match_events_on_match_event_type_id"
  add_index "match_events", ["match_id"], :name => "index_match_events_on_match_id"

  create_table "match_links", :force => true do |t|
    t.integer "match_id"
    t.enum    "link_type", :limit => [:video, :audio, :photo, :review, :other], :default => :other
    t.string  "link_href"
    t.string  "link_text"
  end

  add_index "match_links", ["match_id"], :name => "match_id"

  create_table "matches", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "schedule_id"
  end

  add_index "matches", ["schedule_id"], :name => "match_2_schedule"

  create_table "matches_referees", :id => false, :force => true do |t|
    t.integer "match_id"
    t.integer "referee_id"
  end

  add_index "matches_referees", ["match_id"], :name => "index_matches_referees_on_match_id"
  add_index "matches_referees", ["referee_id"], :name => "index_matches_referees_on_referee_id"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_id"
  end

  add_index "pages", ["tournament_id"], :name => "tournament_id"

  create_table "permissions", :force => true do |t|
    t.integer "admin_id"
    t.string  "controller", :null => false
    t.string  "action",     :null => false
  end

  add_index "permissions", ["admin_id"], :name => "index_permissions_on_admin_id"

  create_table "photo_galleries", :force => true do |t|
  end

  create_table "photos", :force => true do |t|
    t.integer "photo_gallery_id"
    t.string  "title"
    t.string  "filename"
  end

  add_index "photos", ["photo_gallery_id"], :name => "photo_gallery_id"

  create_table "posts", :force => true do |t|
    t.integer  "author_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.enum     "status",        :limit => [:published, :hidden, :updating], :default => :published
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "title",                                                                             :null => false
    t.boolean  "hide_comments",                                             :default => false
    t.string   "short_url"
    t.integer  "tournament_id"
    t.integer  "url_year"
    t.integer  "url_month",     :limit => 2
    t.integer  "url_day",       :limit => 2
  end

  add_index "posts", ["author_id"], :name => "fk_user_post"
  add_index "posts", ["author_id"], :name => "index_posts_on_author_id"
  add_index "posts", ["resource_id", "resource_type"], :name => "index_posts_on_resource_id_and_resource_type"
  add_index "posts", ["tournament_id"], :name => "fk_tournaments_2_posts"
  add_index "posts", ["url_year", "url_month", "url_day", "url"], :name => "index_posts_on_url_year_and_url_month_and_url_day_and_url"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.enum     "gender",              :limit => [:unknown, :male, :female],                                                 :default => :unknown
    t.enum     "user_type",           :limit => [:fan, :footballer],                                                        :default => :fan
    t.enum     "role",                :limit => [:unknown, :ball_boy, :goalkeeper, :fullback, :halfback, :forward, :coach], :default => :unknown
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthday"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "crop_x_left"
    t.integer  "crop_y_top"
    t.integer  "crop_width"
    t.integer  "crop_height"
  end

  add_index "profiles", ["user_id"], :name => "user_id"

  create_table "referees", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name", :null => false
    t.string   "last_name",  :null => false
    t.string   "patronymic"
    t.date     "birth_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "referees", ["user_id"], :name => "user_id"

  create_table "schedules", :force => true do |t|
    t.integer  "venue_id"
    t.date     "match_on"
    t.string   "match_at",      :limit => 5
    t.integer  "host_team_id"
    t.integer  "guest_team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "host_scores"
    t.integer  "guest_scores"
    t.integer  "league_id"
    t.integer  "tour_id"
  end

  add_index "schedules", ["guest_team_id"], :name => "index_schedules_on_guest_team_id"
  add_index "schedules", ["host_team_id"], :name => "index_schedules_on_host_team_id"
  add_index "schedules", ["league_id"], :name => "fk_schedules_step_leagues"
  add_index "schedules", ["tour_id"], :name => "fk_schedules_step_tours"
  add_index "schedules", ["venue_id"], :name => "index_schedules_on_venue_id"

  create_table "seasons", :force => true do |t|
    t.integer  "tournament_id", :null => false
    t.string   "name",          :null => false
    t.string   "url",           :null => false
    t.date     "started_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "seasons", ["tournament_id"], :name => "tournament_id"

  create_table "seasons_teams", :id => false, :force => true do |t|
    t.integer "season_id"
    t.integer "team_id"
  end

  add_index "seasons_teams", ["season_id"], :name => "index_seasons_teams_on_season_id"
  add_index "seasons_teams", ["team_id"], :name => "index_seasons_teams_on_team_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "stages", :force => true do |t|
    t.integer  "season_id",  :null => false
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stages", ["season_id"], :name => "season_id"

  create_table "stats", :force => true do |t|
    t.integer "statable_id"
    t.string  "statable_type"
    t.string  "name"
    t.integer "value"
  end

  add_index "stats", ["name"], :name => "index_stats_on_name"
  add_index "stats", ["statable_id", "statable_type"], :name => "index_stats_on_statable_id_and_statable_type"

  create_table "statuses", :force => true do |t|
    t.string "status_type", :default => "personal"
  end

  create_table "step_properties", :force => true do |t|
    t.string  "property_name"
    t.string  "property_value"
    t.integer "step_id"
  end

  create_table "steps", :force => true do |t|
    t.string   "type"
    t.integer  "tournament_id"
    t.integer  "identifier"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name"
  end

  add_index "steps", ["tournament_id"], :name => "tournament_id"

  create_table "steps_phases", :id => false, :force => true do |t|
    t.integer "step_id"
    t.integer "phase_id"
  end

  create_table "steps_teams", :id => false, :force => true do |t|
    t.integer "step_id"
    t.integer "team_id"
  end

  add_index "steps_teams", ["step_id"], :name => "fk_steps_teams_steps"
  add_index "steps_teams", ["team_id"], :name => "fk_steps_teams_teams"

  create_table "subscribers", :force => true do |t|
    t.integer "post_id"
    t.integer "user_id"
  end

  add_index "subscribers", ["post_id"], :name => "post_id"
  add_index "subscribers", ["user_id"], :name => "user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "teams", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tour_results", :force => true do |t|
    t.integer "season_id"
    t.text    "body"
  end

  add_index "tour_results", ["season_id"], :name => "season_id"

  create_table "tournaments", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name"
  end

  create_table "tours", :force => true do |t|
    t.string  "name",     :null => false
    t.integer "stage_id"
  end

  add_index "tours", ["stage_id"], :name => "tour_2_stage"

  create_table "user_connect_footballer_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "footballer_id"
    t.integer  "provider_uid"
    t.string   "provider"
    t.text     "provider_data"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.boolean  "processed",          :default => false
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",             :limit => 64,                    :null => false
    t.string   "email",                :limit => 100,                   :null => false
    t.boolean  "enabled",                             :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",   :limit => 40,                    :null => false
    t.string   "password_salt",        :limit => 20,                    :null => false
    t.string   "confirmation_token",   :limit => 20
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token", :limit => 20
    t.string   "remember_token",       :limit => 20
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "url"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "page_content"
    t.string   "page_title"
  end

end
