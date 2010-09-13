# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_mailer.default_url_options = { :host => 'football.kharkov.ua' }
config.action_controller.session[:domain]            = 'football.kharkov.ua'
#config.action_view.cache_template_loading            = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

BITLY = {
  :username => 'footballkharkov',
  :api_key => 'R_284aa8534d40494118bf2dadca17695a'
}.freeze

ExceptionNotification::Notifier.exception_recipients = %w(denis.soloshenko@gmail.com)
ExceptionNotification::Notifier.sender_address = %("Football.kharkov.ua" <football.kharkov.ua@gmail.com>)

