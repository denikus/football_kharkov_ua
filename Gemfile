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
gem 'bitly'
gem 'paperclip', '~> 2.7'
gem 'ckeditor'
gem 'sanitize'
gem 'ruby_parser'
gem 'awesome_print'
gem 'oauth2'
#gem 'sass'

#gem 'compass'
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
gem 'jquery-rails'
gem 'turbo-sprockets-rails3', '~>0.3.0'
gem 'pundit'
gem 'rails-sass-images'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~>3.2.6'
  gem 'coffee-rails', ' ~> 3.2.1'
  gem 'uglifier', '>=1.0.3'
end

group :production do
  gem 'exception_notification_rails3', :require => 'exception_notifier'
  gem 'sitemap_generator'
  gem 'whenever', :require => false
  #need this for js compiling
  gem 'execjs'
  gem 'therubyracer'
end

group :development do
  gem 'mongrel', '1.2.0.pre2'
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
  gem 'jazz_hands'
end

# Deploy with Capistrano
gem 'capistrano'

