# 
#  deploy.rb
#  release_notes
#  $Id$
#  
#  Created by mcheck on 2011-09-06.
#  Copyright 2011 Solo Group, Inc.. All rights reserved.
# 

set :user, "techserv"         # The server's user for deploys
# set :scm_passphrase, ""     # The deploy user's password
set :application, 'release_notes'


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


desc "Local staging server code name: lenny"
task :staging do
  # RVM bootstrap, needed since this box is running rvm.  
  $:.unshift(File.expand_path('./lib', ENV['rvm_path']))  # Add RVM's lib directory to the load path.
  require 'rvm/capistrano'                                # Load RVM's capistrano plugin.
  require "bundler/capistrano"
  set :rvm_ruby_string, 'ruby-1.9.2-p290@aidu'            # Whatever env you want it to run in.
  set :rvm_type, :user                                    # Set the user for rvm, or comment out if system install
  
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
  # RVM bootstrap, needed since this box is running rvm.  
  $:.unshift(File.expand_path('./lib', ENV['rvm_path']))  # Add RVM's lib directory to the load path.
  require 'rvm/capistrano'                                # Load RVM's capistrano plugin.
  require "bundler/capistrano"
  set :rvm_ruby_string, 'ruby-1.9.2-p290@aidu'            # Whatever env you want it to run in.
  set :rvm_type, :user                                    # Set the user for rvm, or comment out if system install
  
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


namespace :deploy do
    desc "The start task is used by :cold_deploy to start the application up" 
    task :start, :roles => :app do 
      run "#{sudo} /bin/launchctl load -w /Library/LaunchDaemons/com.passenger_standalone.#{application}.plist" 
    end
    
    desc "Restart the passenger_standalone application process"
    task :restart, :roles => :app do
      run "#{sudo} /bin/launchctl unload -w /Library/LaunchDaemons/com.passenger_standalone.#{application}.plist" 
      run "#{sudo} /bin/launchctl load -w /Library/LaunchDaemons/com.passenger_standalone.#{application}.plist" 
    end
    
    desc "Stop the passenger_standalone application process" 
    task :stop, :roles => :app do 
      run "#{sudo} /bin/launchctl unload -w /Library/LaunchDaemons/com.passenger_standalone.#{application}.plist"
    end 
    
    # desc "Hook to set up database.yml on production server by copying file so passwords are not stored on server.  Brilliant"
    # task :after_update_code, :roles => :app do 
    #   db_config = "#{shared_path}/config/database.yml.production" 
    #   run "cp #{db_config} #{release_path}/config/database.yml" 
    # end 

    desc "svn up the dbapi section of the database"
    task  :dbapi do
      run "svn up #{dbapp_root}/sites/dbapi/aidu --accept theirs-full"
    end

end


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

#server options
ssh_options[:forward_agent] = true  # Use my private keys in order to pull from git
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :repository,  "git@github.com:mojomaze/release_notes.git"
set :branch, "master"             # For newer versions of git

# set :deploy_to, "/home/#{user}/#{domain}"
set :deploy_via, :remote_cache
set :scm_verbose, true
set :use_sudo, false


# after "deploy:update_code", "deploy:update_shared_symlinks"

# after "bundle:install", "deploy:migrate"


# optional task to reconfigure databases
# after "deploy:update_code" , :configure_database
# desc "copy database.yml into the current release path"
# task :configure_database, :roles => :app do
#   db_config = "#{deploy_to}/config/database.yml"
#   run "cp #{db_config} #{release_path}/config/database.yml"
# end


# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

