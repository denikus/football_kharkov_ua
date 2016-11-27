source 'https://rubygems.org'

gem 'rails', '~>4.2'

gem 'rake'
gem 'pg'
gem 'will_paginate', '~> 3.1.0'
gem 'haml'
gem 'hpricot'
gem 'devise'#, '=3.4.1'
gem 'devise-encryptable'
gem 'mini_magick'
gem 'russian'
gem 'cells'
gem 'mime-types'
gem 'bitly', github: 'denikus/bitly'
gem 'cocaine'
gem 'paperclip'#, '4.3'
gem 'ckeditor', '~>4.0.10'
gem 'sanitize'
gem 'ruby_parser'
# gem 'awesome_print'
# gem 'oauth2', '~>1.0.0'
# gem 'omniauth', '~>1.2.0'
# gem 'omniauth-oauth2', '~>1.2.0'
# gem 'omniauth-vkontakte', '~>1.3.3'
# gem 'omniauth-facebook', '~>2.0.0'
gem 'yajl-ruby'
gem 'awesome_nested_set'
gem 'bcrypt', '~> 3.1.7'
# Use SCSS for stylesheets
# gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# gem 'coffee-views'

# for easy config files
gem 'figaro'

#maybe we don't need this
gem 'dynamic_form'

gem 'rails_autolink'
gem 'jquery-rails-cdn'
gem 'pundit'
# gem 'rails-sass-images'
gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
gem 'pry-byebug'
gem 'newrelic_rpm'

gem 'rollbar', '~> 1.0.0'

gem 'metainspector'
gem 'httparty'
gem 'active_model_serializers', '0.9.3'

# gem 'annotate', github: 'ctran/annotate_models'

# Gems used only for assets and not required
# in production environments by default.

# group :assets do
  # gem 'sass-rails', '~>3.2.6'
  # gem 'coffee-rails'#, ' ~> 3.2.1'
  # gem 'uglifier', '>=1.0.3'
  # gem 'turbo-sprockets-rails3', '~>0.3.0'
# end

group :production do
  gem 'sitemap_generator'
  gem 'whenever', :require => false
  #need this for js compiling
  gem 'execjs'
  gem 'therubyracer'
end

group :test do
  gem 'capybara'
  gem 'spork', '~>0.9.0.rc9'
  gem 'factory_girl_rails', '~>4.0'
  gem 'faker'
end

group :development do
  # gem 'capistrano-faster-assets', '~> 1.0'
  gem 'byebug'
  gem 'spring'
  # gem 'jazz_hands'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'database_cleaner'
end

# Deploy with Capistrano
gem 'capistrano',  '~> 3.1'
gem 'capistrano-rails', '~> 1.1.1'
gem 'capistrano-rvm', github: 'capistrano/rvm'
gem 'capistrano-db-tasks', require: false
