require 'capistrano/ext/multistage'
set :stages, %w[staging production]
set :default_stage, "staging"

set :application, "Cashflow"
set :repository,  "git@git.d.ths.kth.se:cashflow.git"
set :scm, :git

set :deploy_to, "/var/rails/#{application}"
set :user, "capistrano"
set :use_sudo, false
set :ssh_options, {:forward_agent => true}
set :rails_env, "migration"
set :tmp_path, "/var/tmp/rails"
set :keep_releases, 3

role :web, "magic-brownies.ben-and-jerrys.stacken.kth.se"                          # Your HTTP server, Apache/etc
role :app, "magic-brownies.ben-and-jerrys.stacken.kth.se"                          # This may be the same as your `Web` server
role :db,  "magic-brownies.ben-and-jerrys.stacken.kth.se", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Copy the config files"
  task :update_config do
    run "cp -Rf #{shared_path}/config/* #{release_path}/config/"
    run "ln -sf #{release_path}/config/environments/development.rb #{release_path}/config/environments/migration.rb"
    run "ln -sf #{release_path}/config/environments/production.rb #{release_path}/config/environments/staging.rb"
  end

  desc "Symlink tmp"
  task :symlink_tmp do
    run "rm -rf #{release_path}/tmp"
    run "ln -sf #{tmp_path}/#{application}/#{stage} #{release_path}/tmp"
  end

  desc "Set permissions for public/{stylesheets,javascripts}"
  task :set_permissions do
    run "setfacl -m u:www-data:rwx #{release_path}/public/{stylesheets,javascripts}"
    run "setfacl -d -m u:www-data:rwx #{release_path}/public/{stylesheets,javascripts}"
  end
  
  after "deploy:update_code", "deploy:update_config"
  after "deploy:update_code", "deploy:symlink_tmp"
  # after "deploy:update_code", "deploy:update_revision_partial"
  after "deploy:update", "deploy:cleanup"
    
end
