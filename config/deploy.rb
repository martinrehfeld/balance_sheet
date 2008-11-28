# =============================================================================
# CONFIGURATION
# =============================================================================
set :application,       "balance_sheet"
set :use_sudo,          false
set :run_method,        :run

set :scm,               "git"
set :deploy_via,        :remote_cache
set :deploy_to,         "/var/rails/#{application}"

set :user,       "www-data"
set :repository, "git@development.local:balance_sheet.git"
set :branch,     "master"

role :app, "media.local"
role :web, "media.local"
role :db,  "media.local", :primary => true

set :apacheinitscript, "/etc/init.d/apache2"

# =============================================================================
# TASKS
# =============================================================================

namespace :apache do
  
  desc "Start webserver (Apache)"
  task :start, :roles => :web do
    sudo "#{apacheinitscript} start"
  end

  desc "Stop webserver (Apache)"
  task :stop, :roles => :web do
    sudo "#{apacheinitscript} stop"
  end
  
  desc "Reload webserver config (Apache)"
  task :reload, :roles => :web do
    sudo "#{apacheinitscript} reload"
  end
  
  desc "Force reload of webserver config (Apache)"
  task :forcereload, :roles => :web do
    sudo "#{apacheinitscript} force-reload"
  end
  
end

namespace :deploy do

  [:start, :stop].each do |t|
    desc "#{t.to_s.capitalize} task is a no-op with Passenger"
    task t, :roles => :app do ; end
  end
    
  desc "Restart Application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
end
