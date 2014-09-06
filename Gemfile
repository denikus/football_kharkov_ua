source 'http://rubygems.org'

gem 'rails', '3.2.13'

gem 'rake', '>= 0.8.9'
#gem 'mysql2'
gem 'pg'
gem 'will_paginate', '~> 3.0'
gem 'haml'
gem 'devise', '2.0.4'
gem 'mini_magick'
gem 'hpricot'
gem 'russian'
gem 'cells'
gem "mime-types"
gem 'bitly', '~>0.10.1'
gem 'cocaine'
gem 'paperclip', '~> 4.1'
gem 'ckeditor'
gem 'sanitize'
gem 'ruby_parser'
gem 'awesome_print'
gem 'oauth2'
gem 'omniauth', '>=0.2.5'
gem 'omniauth-vkontakte'
gem 'omniauth-facebook'
gem 'yajl-ruby'
gem 'awesome_nested_set'

# for easy config files
gem 'figaro'

#maybe we don't need this
gem 'dynamic_form'

gem 'rails_autolink'
gem 'jquery-rails-cdn'
gem 'turbo-sprockets-rails3', '~>0.3.0'
gem 'pundit'
gem 'rails-sass-images'
gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
gem 'pry-byebug'
gem 'newrelic_rpm'

gem 'rollbar', '~> 1.0.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~>3.2.6'
  gem 'coffee-rails', ' ~> 3.2.1'
  gem 'uglifier', '>=1.0.3'
end

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

group :development, :test do
  gem 'rspec-rails', :branch => 'rails3'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'database_cleaner'
end

# Deploy with Capistrano
gem 'capistrano',  '~> 3.1'
gem 'capistrano-rails', '~> 1.1'
gem 'capistrano-rvm', github: 'capistrano/rvm'

