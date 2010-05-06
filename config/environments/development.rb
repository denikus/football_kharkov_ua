require "ap"
# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
#config.action_view.cache_template_extensions         = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

FORUM = {
  :location => 'http://forum.football.kharkov.ua/',
  :create_user => 'create_user.php',
  :confirm_user => 'confirm_user.php',
  :secret => 'b261638d90968ece3bc564296fa28c486c8e4963c6a380247a4875508c6b9f5f686df12f9f9464e6520ced86a0602ccc1ed6cdff0cfd4d8bd1b480187313c859'
}.freeze