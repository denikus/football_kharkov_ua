# -*- encoding : utf-8 -*-
FootballKharkov::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  #config.log_level = :debug


  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = true

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Choose the compressors to use
  # config.assets.js_compressor  = :uglifier
  # config.assets.css_compressor = :yui

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( application/schedule/schedule.js jquery-plugins/jquery_form/jquery.form.js application/comment/comment.js ckeditor/init.js jquery-plugins/fancybox/jquery.fancybox-1.3.4.pack.js jquery-plugins/fancybox/jquery.easing-1.3.pack.js user.css styles.css jquery-plugins/jquery-ui-1.8.4.custom/js/jquery-ui-1.8.4.custom.min.js application/itleague_draw.js /javascripts/jquery-plugins/jquery-ui-1.8.4.custom/css/redmond/jquery-ui-1.8.4.custom.css itleague_draw.css jquery-plugins/jquery.jcrop.css application/profile/profile.js jquery-plugins/jquery.jcrop.min.js)

  config.action_mailer.default_url_options = { :host => 'football.kharkov.ua' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
#    :domain               => 'football.kharkov.ua',
    :user_name            => 'football.kharkov.ua@gmail.com',
    :password             => '7SieoNCoNEkQ',
    :authentication       => 'plain',
    :enable_starttls_auto => true  }


  config.middleware.use ExceptionNotifier,
    :email_prefix => "[fhu_error]",
    :sender_address => %{"notifier" <info@football.kharkov.ua>},
    :exception_recipients => %w{denis.soloshenko@gmail.com}

  config.action_dispatch.tld_length = 2

  BITLY = {
    :username => 'footballkharkov',
    :api_key => 'R_284aa8534d40494118bf2dadca17695a'
  }.freeze


  MEGA_USER = [1, 107, 74, 87]
end
