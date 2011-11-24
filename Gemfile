source 'http://rubygems.org'

gem 'rails', '3.0.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'rake', '~> 0.8.7'
gem 'rake', '>= 0.8.9'
#gem 'mysql2', '=0.2.7'
gem 'mysql2', '0.2.11'
gem 'will_paginate', '~> 3.0.beta'
gem 'mongrel'
gem 'haml'
gem 'devise', '=1.1.8'
gem 'mini_magick'
gem 'hpricot'
gem 'russian'
#gem 'rutils'
gem 'cells'
gem 'mime-types', :require => 'mime/types'
gem 'bitly'
gem "paperclip", "~> 2.3"
gem 'ckeditor', :git => 'git://github.com/galetahub/rails-ckeditor.git', :branch => 'rails3'
gem 'sanitize'
gem 'ruby_parser'
gem 'enum_column', :git => 'git://github.com/electronick/enum_column.git'
gem 'awesome_print'
gem 'ruby-debug'
gem 'oauth2'
gem 'jquery-rails', '>= 0.2.6'
#gem 'sass', '3.1.0.alpha.216'
gem 'sass'
gem 'compass'
gem 'omniauth', '>=0.2.5'
gem 'yajl-ruby'

group :production do
  gem 'exception_notification_rails3', :require => 'exception_notifier'
  gem 'sitemap_generator'
  gem 'whenever', :require => false
end

group :development do
  gem 'newrelic_rpm'
  gem 'fancy-buttons'
  gem 'newrelic_rpm'
end

group :test do
  # gem 'ZenTest'
  # gem 'autotest-rails'
  gem "capybara"
  gem "guard-rspec"
  gem "spork", "~> 0.9.0.rc"
  gem 'factory_girl_rails'
  # gem 'redgreen'
  # gem 'test_notifier'
end

group :development, :test do 
  gem 'rspec-rails', :branch => 'rails3'
  gem "guard-rspec"
  gem "guard-spork"
  gem 'growl_notify', :require => false if RUBY_PLATFORM =~/darwin/i
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~/darwin/i
end
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
