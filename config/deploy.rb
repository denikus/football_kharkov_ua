require 'capistrano-db-tasks'

# config valid only for Capistrano 3.2.1
lock '3.2.1'

# DB SYNC SETTINGS
# if you want to remove the local dump file after loading
set :db_local_clean, false

# if you want to remove the dump file from the server after downloading
set :db_remote_clean, true

# if you want to exclude table from dump
set :db_ignore_tables, []

# if you want to exclude table data (but not table schema) from dump
set :db_ignore_data_tables, []

# if you are highly paranoid and want to prevent any push operation to the server
set :disallow_pushing, true

# if you prefer bzip2/unbzip2 instead of gzip
# set :compressor, :bzip2

# If you want to import assets, you can change default asset dir (default = system)
# This directory must be in your shared directory on the server
# set :assets_dir, %w(public/assets public/att)
# set :local_assets_dir, %w(public/assets public/att)

# GENERAL SETTINGS
# repo vars
set :scm, :git
set :repo_url, 'git@github.com:denikus/football_kharkov_ua.git'

# output format
set :format, :pretty
set :log_level, :info #:debug

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/application.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp public/system public/ckeditor_assets public/footballers}

# Rails assets options
set :assets_roles, [:all]

set :ssh_options, :compression => false, :keepalive => true


# =========================
# Additional tasks
# =========================
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:all), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  # before 'deploy:symlink:shared', :update_linked_files
  after :publishing, :restart

end


# require 'bundler/capistrano'
# set :application, "football_kharkov_ua"
# set :repository,  "git@github.com:denikus/football_kharkov_ua.git"
# set :user, "denix"
# set :use_sudo, false
# set :scm, :git
# set :branch, "master"
# set :deploy_via, :remote_cache
#
# set :deploy_env, 'production'
# set :deploy_to, "/home/denix/vhosts/#{application}"
# set :port, 3089
# server "178.79.139.151", :app, :web, :primary => true
#
#
# # Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
#
# #role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# #role :app, "your app-server here"                          # This may be the same as your `Web` server
# #role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# #role :db,  "your slave db-server here"
#
# # if you're still using the script/reaper helper you will need
# # these http://github.com/rails/irs_process_scripts
#
# set :default_environment, {
#   'PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p327@rails3.2/bin:/home/denix/.rvm/bin:$PATH",
#   'RUBY_VERSION' => '1.9.3',
#   'GEM_HOME' => '/usr/local/rvm/gems/ruby-1.9.3-p327@rails3.2',
#   'GEM_PATH' => '/usr/local/rvm/gems/ruby-1.9.3-p327@rails3.2:/usr/local/rvm/gems/ruby-1.9.3-p327@rails3.2'
# }
#
#
# after "deploy", "deploy:bundle_gems"
# after "deploy:bundle_gems", "deploy:update_shared_symlinks"
# after "deploy:update_shared_symlinks", "deploy:perform_migrations"
# after "deploy:perform_migrations" , "deploy:compile_assets"
# after "deploy:compile_assets" , "deploy:restart"
# after "deploy:update_code", "deploy:cleanup"
#
#
# # If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :perform_migrations do
#     run "cd #{release_path} && bundle exec  /usr/local/rvm/gems/ruby-1.9.3-p125@rails3.2/bin/rake db:migrate RAILS_ENV=production"
#   end
#
#   task :bundle_gems do
#     #run "cd #{deploy_to}/current && bundle install --system"
#     run "cd #{release_path} && bundle install --system"
#   end
#
#   task :start do
#    run "/etc/init.d/nginx start"
#   end
#
#   task :stop do
#    run "/etc/init.d/nginx stop"
#   end
#
#   task :restart, :roles => :app, :except => { :no_release => true } do
#    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
#
#   task :update_shared_symlinks do
#     run "mkdir #{File.join(release_path)}/public/assets"
#     %w(config/database.yml config/application.yml public/ckeditor_assets public/footballers public/assets/sources_manifest.yml public/assets/manifest.yml).each do |path|
#       run "rm -rf #{File.join(release_path, path)}"
#       run "ln -s #{File.join(deploy_to, "shared", path)} #{File.join(release_path, path)}"
#     end
#   end
#
#   task :compile_assets do
#     #run "cd #{deploy_to}/current && RAILS_ENV=production bundle exec /usr/local/rvm/gems/ruby-1.9.3-p125@rails3.2/bin/rake assets:precompile"
#     #copy source manifest file here
#     #path = 'public/assets/sources_manifest.yml'
#     #run "mkdir #{File.join(release_path)}/public/assets"
#     #run "ln -s #{File.join(deploy_to, "shared", path)} #{File.join(release_path, path)}"
#
#     run "cd #{release_path} && RAILS_ENV=production bundle exec /usr/local/rvm/gems/ruby-1.9.3-p125@rails3.2/bin/rake assets:precompile"
#     #
#     #run "rm -rf #{File.join(release_path, path)}"
#     #run "ln -s #{File.join(deploy_to, "shared", path)} #{File.join(release_path, path)}"
#   end
# end