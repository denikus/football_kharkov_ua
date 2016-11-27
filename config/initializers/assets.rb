# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( admin/application.css admin/admin.css user.css itleague_draw.js itleague_draw.css admin/temp.js jquery-plugins/jquery-ui-1.8.4.custom/js/jquery-ui-1.8.4.custom.min.js extensions.js)
# Rails.application.config.assets.precompile += %w( /vendor/assets/images/default/**/*.gif)
Rails.application.config.assets.precompile += ['jquery.js', 'jquery.min.js']