set :application, "football.kharkov.ua"
set :repository,  "http://svn.assembla.com/svn/football_kharkov_ua/trunk"

set :scm_username, 'denix'
set :scm_password, proc{Capistrano::CLI.password_prompt('SVN pass:' )}


# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "207.210.117.112"
role :web, "207.210.117.112"
role :db,  "207.210.117.112", :primary => true

set :user, "denix"
set :use_sudo, false
set :password, "W1IDPB1lTaOo9VILGdGr"
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :export
#set :ssh_keys, %w()
ssh_options[:keys] = %w(/home/denix/.ssh/id_rsa_tektonic)
ssh_options[:port] = 3576
#ssh_options[:forward_agent] = true

