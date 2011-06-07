desc "Echo the server's host information"
task :uname do 
  run "uname -a"
end

namespace :deploy do
  desc "Delete the cached-copy folder to create a fresh checkout on next deploy"
  task :reset_cache do
    run "rm -fr #{shared_path}/cached-copy"
  end
end


# miscellaneous options
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_via, :remote_cache
set :branch, "master"         # For newer versions of git
# set :branch, "origin/master"    # For older versions of git
set :scm_verbose, true
set :use_sudo, false

# you might need to set this if you aren't seeing password prompts
default_run_options[:pty] = true  # Must be set for the password prompt from git to work

# As Capistrano executes in a non-interactive mode and therefore doesn't cause
# any of your shell profile scripts to be run, the following might be needed
# if (for example) you have locally installed gems or applications. Note:
# this needs to contain the full values for the variables set, not simply
# the deltas.
# default_environment['PATH']='<your paths>:/usr/local/bin:/usr/bin:/bin'
default_environment['PATH']='/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:/opt/subversion/bin:/opt/local/apache2/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin'
# default_environment['GEM_PATH']='<your paths>:/usr/lib/ruby/gems/1.8'



# be sure to change these
set :user, 'techserv'
set :application, 'release_notes'
set :user, "techserv"  # The server's user for deploys
set :scm_passphrase, "qbf_j0ld"  # The deploy user's password

set :repository,  "git@github.com:mojomaze/release_notes.git"
ssh_options[:forward_agent] = true  # Use my private keys in order to pull from git


desc "Local staging server code name: lenny"
task :staging do
  set :repository,  "git@github.com:mojomaze/release_notes.git"
  set :domain, "lenny.sologroup.com"
  role :app, domain
  role :web, domain
  role :db, domain, :primary => true
  set :deploy_to, "/Users/Shared/SGI/#{application}"
  set :rails_env, 'staging'
end


desc "The production server, code name: leonard"
task :production do
  set :repository,  "git@github.com:mojomaze/release_notes.git"
  set :domain, "lenny.sologroup.com"
  role :app, domain
  role :web, domain
  role :db, domain, :primary => true
  set :deploy_to, "/Users/Shared/SGI/#{application}"
  set :rails_env, 'production'
  # If we are deploying, the cache will be reset and it will always pull down a fresh copy.
  # before "deploy:update", "deploy:reset_cache"
end



# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end