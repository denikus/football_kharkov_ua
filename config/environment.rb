# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
 
Rails::Initializer.run do |config|
  #config.gem 'yaroslav-russian', :lib => 'russian', :source => 'http://gems.github.com'
  config.gem 'russian', :source => 'http://gemcutter.org'
  config.gem 'warden'
  config.gem 'devise'
#  config.gem 'devise'
#  , :version => '0.7.3'
  config.gem 'mime-types', :lib => 'mime/types'
  config.gem "nested_layouts", :source => "http://gemcutter.org"
  config.gem "bitly"
  config.gem "paperclip"
  config.gem "compass", :version => ">= 0.10.2"
  config.gem "cells"
  config.gem 'subdomain-fu'
  config.gem 'exception_notification'


  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
#   config.load_paths += %W(#{RAILS_ROOT}/app/middleware)


  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_football_session',
    :secret      => '28b29886499fa272910307eb7cf9b0bcd1fcf54531bac8538d915f3ebb907239ee7173504f6884d0f377912fa58359aaef06315516867bb6e55bd4901b59cefc'
  }

#  config.load_paths << "#{RAILS_ROOT}/app/middleware"

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
   config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :comment_observer

#  config.time_zone = 'Kyev'

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = 'Kyev'

end
require File.dirname(__FILE__) + '/../lib/lib'

#class CGI::Session
#  alias original_initialize initialize
#
#  def initialize(request, option = {})
#    if option['swfupload'] == true && !request.env_table["QUERY_STRING"].nil?
#    tmp = request.env_table["QUERY_STRING"].match(/^.*_session_id=(.*)$/)
#      if tmp and tmp[1]
#        option['session_id'] = tmp[1]
#      end
#    end
#
#    original_initialize(request, option)
#  end
#end
#require 'will_paginate'
require 'rutils'
require 'hpricot'
#RuTils::overrides = true