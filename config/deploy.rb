# =============================================================================
# CONFIGURATION
# =============================================================================
set :application,       'balance_sheet'
set :use_sudo,          false
set :run_method,        :run

set :scm,               'git'
set :deploy_via,        :remote_cache

set :user,              'www-data'
set :repository,        'git@extranet.local:balance_sheet.git'
set :branch,            'master'

role :app,              'intranet.local'
role :web,              'intranet.local'
role :db,               'intranet.local', :primary => true

set :bundle_without,    [:development, :test, :tools]
require 'bundler/capistrano'

set :apacheinitscript,  '/etc/init.d/apache2'


# =============================================================================
# TASKS
# =============================================================================

namespace :apache do

  desc 'Start webserver (Apache)'
  task :start, :roles => :web do
    sudo "#{apacheinitscript} start"
  end

  desc 'Stop webserver (Apache)'
  task :stop, :roles => :web do
    sudo "#{apacheinitscript} stop"
  end

  desc 'Reload webserver config (Apache)'
  task :reload, :roles => :web do
    sudo "#{apacheinitscript} reload"
  end

  desc 'Force reload of webserver config (Apache)'
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
