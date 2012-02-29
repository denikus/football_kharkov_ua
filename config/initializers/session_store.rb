# -*- encoding : utf-8 -*-
# Be sure to restart your server when you modify this file.

#FootballKharkov::Application.config.session_store :cookie_store, :key => '_football_kharkov_session', :domain => :all
#FootballKharkov::Application.config.session_store :cookie_store, :key => '_football_kharkov_session', :domain => '.football.kharkov.ua'
domain = Rails.env == "production" ? '.football.kharkov.ua' : '.football.lvh.me'

FootballKharkov::Application.config.session_store :cookie_store, :key => '_football_kharkov_session', :domain => domain
#Rails.application.

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# FootballKharkov::Application.config.session_store :active_record_store
