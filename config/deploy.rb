require 'bundler/capistrano'
set :application, "football.kharkov.ua"
set :repository,  "git@git.assembla.com:football_kharkov_ua.git"
set :user, "denix"
set :use_sudo, false
set :scm, :git
set :branch, "master"

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p125@rails3.2/bin:/home/denix/.rvm/bin:$PATH",
  'RUBY_VERSION' => '1.9.3',
  'GEM_HOME' => '/usr/local/rvm/gems/ruby-1.9.3-p125@rails3.2',
  'GEM_PATH' => '/usr/local/rvm/gems/ruby-1.9.3-p125@rails3.2:/usr/local/rvm/gems/ruby-1.9.3-p125@global'
}


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :perform_migrations do
    run "cd #{deploy_to}/current && /usr/local/rvm/gems/ruby-1.9.3-p125@rails3.2/bin/rake db:migrate RAILS_ENV=production"
  end

  task :bundle_gems do
    run "cd #{deploy_to}/current && bundle install --system"
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
    %w(config/database.yml).each do |path|
      run "rm -rf #{File.join(release_path, path)}"
      run "ln -s #{File.join(deploy_to, "shared", path)} #{File.join(release_path, path)}"
    end
  end

  task :compile_assets do
    run "cd #{deploy_to}/current && RAILS_ENV=production bundle exec /home/denix/.rvm/gems/ruby-1.9.3-head@rails3.2/bin/rake assets:precompile"
  end
end