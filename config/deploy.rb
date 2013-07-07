require 'bundler/capistrano'
set :application, "football_kharkov_ua"
set :repository,  "git@github.com:denikus/football_kharkov_ua.git"
set :user, "denix"
set :use_sudo, false
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache

set :deploy_env, 'production'
set :deploy_to, "/home/denix/vhosts/#{application}"
set :port, 3089
server "178.79.139.151", :app, :web, :primary => true


# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p327@rails3.2/bin:/home/denix/.rvm/bin:$PATH",
  'RUBY_VERSION' => '1.9.3',
  'GEM_HOME' => '/usr/local/rvm/gems/ruby-1.9.3-p327@rails3.2',
  'GEM_PATH' => '/usr/local/rvm/gems/ruby-1.9.3-p327@rails3.2:/usr/local/rvm/gems/ruby-1.9.3-p327@rails3.2'
}


after "deploy", "deploy:bundle_gems"
after "deploy:bundle_gems", "deploy:update_shared_symlinks"
after "deploy:update_shared_symlinks", "deploy:perform_migrations"
after "deploy:perform_migrations" , "deploy:compile_assets"
after "deploy:compile_assets" , "deploy:restart"
after "deploy:update_code", "deploy:cleanup"


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :perform_migrations do
    run "cd #{release_path} && bundle exec  /usr/local/rvm/gems/ruby-1.9.3-p125@rails3.2/bin/rake db:migrate RAILS_ENV=production"
  end

  task :bundle_gems do
    #run "cd #{deploy_to}/current && bundle install --system"
    run "cd #{release_path} && bundle install --system"
  end

  task :start do
   run "/etc/init.d/nginx start"
  end

  task :stop do
   run "/etc/init.d/nginx stop"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :update_shared_symlinks do
    %w(config/database.yml public/ckeditor_assets public/footballers).each do |path|
      run "rm -rf #{File.join(release_path, path)}"
      run "ln -s #{File.join(deploy_to, "shared", path)} #{File.join(release_path, path)}"
    end
  end

  task :compile_assets do
    #run "cd #{deploy_to}/current && RAILS_ENV=production bundle exec /usr/local/rvm/gems/ruby-1.9.3-p125@rails3.2/bin/rake assets:precompile"
    #copy source manifest file here
    path = 'public/assets/sources_manifest.yml'
    run "mkdir #{File.join(release_path)}/public/assets"
    run "ln -s #{File.join(deploy_to, "shared", path)} #{File.join(release_path, path)}"

    run "cd #{release_path} && RAILS_ENV=production bundle exec /usr/local/rvm/gems/ruby-1.9.3-p125@rails3.2/bin/rake assets:precompile"
    #
    #run "rm -rf #{File.join(release_path, path)}"
    #run "ln -s #{File.join(deploy_to, "shared", path)} #{File.join(release_path, path)}"
  end
end