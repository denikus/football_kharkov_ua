# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20160918125144) do

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

  create_table "applications", :force => true do |t|
    t.integer  "team_id"
    t.integer  "owner_id"
    t.integer  "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_images", :force => true do |t|
    t.integer "article_id"
    t.string  "file"
    t.string  "title"
  end

  add_index "article_images", ["article_id"], :name => "article_images_article_id"

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
    t.integer  "locale",            :limit => 2,  :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "ckeditor_assets_assetable_type_assetable_id"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "ckeditor_assets_assetable_type_type_assetable_id"
  add_index "ckeditor_assets", ["user_id"], :name => "ckeditor_assets_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "lft",        :null => false
    t.integer  "rgt",        :null => false
    t.integer  "post_id"
    t.integer  "author_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "source"
  end

  add_index "comments", ["author_id"], :name => "comments_author_id"
  add_index "comments", ["post_id"], :name => "comments_post_id"

  create_table "competitors", :force => true do |t|
    t.integer "match_id",                                   :null => false
    t.string  "side",     :limit => 7, :default => "hosts"
    t.integer "team_id",                                    :null => false
    t.integer "score",    :limit => 2, :default => 0,       :null => false
    t.integer "fouls",    :limit => 2, :default => 0,       :null => false
  end

  add_index "competitors", ["match_id"], :name => "competitors_match_id"
  add_index "competitors", ["team_id"], :name => "competitors_team_id"

  create_table "contents", :force => true do |t|
    t.string   "title",      :null => false
    t.text     "body"
    t.string   "type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["author_id"], :name => "contents_author_id"

  create_table "football_player_appointments", :force => true do |t|
    t.integer "competitor_id"
    t.integer "footballer_id"
    t.string  "response",      :limit => 14, :default => "not_responded"
  end

  create_table "football_players", :force => true do |t|
    t.integer "competitor_id",              :null => false
    t.integer "footballer_id",              :null => false
    t.integer "number",        :limit => 2, :null => false
  end

  add_index "football_players", ["competitor_id"], :name => "football_players_competitor_id"
  add_index "football_players", ["footballer_id"], :name => "football_players_footballer_id"

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
    t.integer  "ott_player_id"
    t.string   "ott_uid"
    t.string   "ott_path"
  end

  add_index "footballers", ["user_id"], :name => "footballers_user_id"

  create_table "footballers_teams", :id => false, :force => true do |t|
    t.integer "footballer_id"
    t.integer "team_id"
    t.integer "step_id"
  end

  add_index "footballers_teams", ["footballer_id"], :name => "footballers_teams_footballer_id"
  add_index "footballers_teams", ["step_id"], :name => "footballers_teams_step_id"
  add_index "footballers_teams", ["team_id"], :name => "footballers_teams_team_id"

  create_table "league_tags", :force => true do |t|
    t.integer  "step_season_id"
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "leagues_league_tags", :force => true do |t|
    t.integer  "step_league_id"
    t.integer  "league_tag_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

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

  add_index "match_events", ["match_event_type_id"], :name => "match_events_match_event_type_id"
  add_index "match_events", ["match_id"], :name => "match_events_match_id"

  create_table "match_links", :force => true do |t|
    t.integer "match_id"
    t.string  "link_type", :limit => 6, :default => "other"
    t.string  "link_href"
    t.string  "link_text"
  end

  add_index "match_links", ["match_id"], :name => "match_links_match_id"

  create_table "matches", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "schedule_id"
  end

  add_index "matches", ["schedule_id"], :name => "matches_schedule_id"

  create_table "matches_referees", :id => false, :force => true do |t|
    t.integer "match_id"
    t.integer "referee_id"
  end

  add_index "matches_referees", ["match_id"], :name => "matches_referees_match_id"
  add_index "matches_referees", ["referee_id"], :name => "matches_referees_referee_id"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_id"
  end

  add_index "pages", ["tournament_id"], :name => "pages_tournament_id"

  create_table "permissions", :force => true do |t|
    t.integer "admin_id"
    t.string  "controller", :null => false
    t.string  "action",     :null => false
  end

  add_index "permissions", ["admin_id"], :name => "permissions_admin_id"

  create_table "photo_galleries", :force => true do |t|
  end

  create_table "photos", :force => true do |t|
    t.integer "photo_gallery_id"
    t.string  "title"
    t.string  "filename"
  end

  add_index "photos", ["photo_gallery_id"], :name => "photos_photo_gallery_id"

  create_table "posts", :force => true do |t|
    t.integer  "author_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.string   "status",        :limit => 10, :default => "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "title",                                                :null => false
    t.boolean  "hide_comments",               :default => false
    t.string   "short_url"
    t.integer  "tournament_id"
    t.integer  "url_year"
    t.integer  "url_month",     :limit => 2
    t.integer  "url_day",       :limit => 2
    t.string   "path"
  end

  add_index "posts", ["author_id"], :name => "posts_author_id"
  add_index "posts", ["resource_id", "resource_type"], :name => "posts_resource_id_resource_type"
  add_index "posts", ["tournament_id"], :name => "posts_tournament_id"
  add_index "posts", ["url_year", "url_month", "url_day", "url"], :name => "posts_url_year_url_month_url_day_url"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "gender",              :limit => 8,  :default => "unknown"
    t.string   "user_type",           :limit => 11, :default => "fan"
    t.string   "role",                :limit => 10, :default => "unknown"
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

  add_index "profiles", ["user_id"], :name => "profiles_user_id"

  create_table "referees", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name", :null => false
    t.string   "last_name",  :null => false
    t.string   "patronymic"
    t.date     "birth_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "referees", ["user_id"], :name => "referees_user_id"

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

  add_index "schedules", ["guest_team_id"], :name => "schedules_guest_team_id"
  add_index "schedules", ["host_team_id"], :name => "schedules_host_team_id"
  add_index "schedules", ["league_id"], :name => "schedules_league_id"
  add_index "schedules", ["tour_id"], :name => "schedules_tour_id"
  add_index "schedules", ["venue_id"], :name => "schedules_venue_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "sessions_session_id"
  add_index "sessions", ["updated_at"], :name => "sessions_updated_at"

  create_table "stats", :force => true do |t|
    t.integer "statable_id"
    t.string  "statable_type"
    t.string  "name"
    t.integer "value"
  end

  add_index "stats", ["name"], :name => "stats_name"
  add_index "stats", ["statable_id", "statable_type"], :name => "stats_statable_id_statable_type"

  create_table "statuses", :force => true do |t|
    t.string "status_type", :default => "personal"
  end

  create_table "step_properties", :force => true do |t|
    t.integer "step_id"
    t.string  "property_name"
    t.string  "property_value"
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

  add_index "steps", ["tournament_id"], :name => "steps_tournament_id"

  create_table "steps_phases", :id => false, :force => true do |t|
    t.integer "step_id"
    t.integer "phase_id"
  end

  create_table "steps_teams", :id => false, :force => true do |t|
    t.integer "step_id"
    t.integer "team_id"
  end

  add_index "steps_teams", ["step_id"], :name => "steps_teams_step_id"
  add_index "steps_teams", ["team_id"], :name => "steps_teams_team_id"

  create_table "subscribers", :force => true do |t|
    t.integer "post_id"
    t.integer "user_id"
  end

  add_index "subscribers", ["post_id"], :name => "subscribers_post_id"
  add_index "subscribers", ["user_id"], :name => "subscribers_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "taggings_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "taggings_taggable_id_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "teams", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ott_uid"
    t.string   "ott_path"
  end

  create_table "tournaments", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name"
  end

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
    t.string   "username",               :limit => 64,                    :null => false
    t.string   "email",                  :limit => 100,                   :null => false
    t.boolean  "enabled",                               :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",                                      :null => false
    t.string   "password_salt",                                           :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "unconfirmed_email"
    t.datetime "reset_password_sent_at"
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
