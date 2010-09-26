# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_mailer.default_url_options             = { :host => 'football.kharkov.ua' }
config.action_controller.session[:domain]            = 'football.kharkov.ua'
default_url_options[:host]                           = 'football.kharkov.ua'
#config.action_view.cache_template_loading            = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => false
}
#ActionMailer::Base.default_url_options[:host] = "football.kharkov.ua"

FORUM = {
  :location => 'http://forum.football.kharkov.ua/',
  :create_user => 'create_user.php',
  :confirm_user => 'confirm_user.php',
  :secret => 'b261638d90968ece3bc564296fa28c486c8e4963c6a380247a4875508c6b9f5f686df12f9f9464e6520ced86a0602ccc1ed6cdff0cfd4d8bd1b480187313c859'
}.freeze

BITLY = {
  :username => 'footballkharkov',
  :api_key => 'R_284aa8534d40494118bf2dadca17695a'
}.freeze


