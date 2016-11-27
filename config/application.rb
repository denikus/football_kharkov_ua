# -*- encoding : utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FootballKharkov
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    # TODO restore in other file
    # config.autoload_paths += %W(#{Rails.root}/lib/*.rb #{Rails.root}/app/models/ckeditor)
    #config.autoload_paths += %W(#{Rails.root}/app/models/ckeditor)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Kyiv'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)


    # Configure the default encoding used in templates for Ruby 1.9.
    # config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    # config.filter_parameters += [:password]

    # Enable the asset pipeline
    # config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    # config.assets.version = '1.0'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # config.action_view.javascript_expansions[:defaults] = %w(rails)
  end
end
