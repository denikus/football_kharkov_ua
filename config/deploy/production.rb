# Stage vars
# ======================
set :application, "football.kharkov.ua"
set :stage, :production
set :user, "denix"
set :deploy_env, 'production'
set :rails_env, 'production'
set :host, 'football.kharkov.ua'
set :deploy_to, "/home/denix/vhosts/#{fetch(:application)}"

# Git branch
set :branch, 'master'

# Extended Server Syntax
# ======================
server '85.159.209.246', roles: %w(app db web), user: fetch(:user), port: 34597


# Shell env
# ======================
set :default_env, { path: "~/.rvm/gems/ruby-2.1.2@fhu/bin:~/.rvm/bin:$PATH" }
