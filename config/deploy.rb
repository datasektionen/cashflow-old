require 'capistrano/ext/multistage'
set :stages, %w(staging production)
set :default_stage, "staging"

set :application, "cashflow"
set :repository, "git@turtle-soup.ben-and-jerrys.stacken.kth.se:cashflow.git"
set :scm, "git"
set :deploy_to, "/var/rails/#{application}" # Will be updated for each stage with stage specific path.
set :user, "capistrano"
set :use_sudo, false
set :rails_env, "migration"
set :tmp_path, "/var/tmp/rails"
set :keep_releases, 3

ssh_options[:forward_agent] = true

role :app, "magic-brownies.ben-and-jerrys.stacken.kth.se"
role :web, "magic-brownies.ben-and-jerrys.stacken.kth.se"
role :db,  "magic-brownies.ben-and-jerrys.stacken.kth.se", :primary => true

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
  end

  desc "Symlink tmp"
  task :symlink_tmp do
    run "rm -rf #{release_path}/tmp"
    run "ln -sf #{tmp_path}/#{application}/#{stage} #{release_path}/tmp"
  end

  desc "Set permissions for public/{stylesheets,javascripts}"
  task :set_permissions do
    #run "setfacl -m user:www-data:rwx #{release_path}/public/{stylesheets,javascripts}"
    #run "setfacl -d -m user:www-data:rwx #{release_path}/public/{stylesheets,javascripts}"
  end

  after  "deploy:update_code", "deploy:update_config"
  after  "deploy:update_code", "deploy:symlink_tmp"
  after  "deploy:update_code", "deploy:set_permissions"
  after  "deploy:update", "deploy:cleanup"
end

namespace :bundler do
  namespace :bundler do  
    task :create_symlink, :roles => :app do
      set :bundle_dir, 'vendor/bundle'
      set :shared_bundle_path, File.join(shared_path, 'bundle')
      
      run " cd #{release_path} && rm -rf #{bundle_dir}" # in the event it already exists..?
      run "mkdir -p #{shared_bundle_path} && cd #{release_path} && ln -s #{shared_bundle_path} #{bundle_dir}"
    end
  end

  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} ; bundle install --path #{shared_bundle_path} --without development test"
  end
end
 
after 'deploy:update_code', 'bundler:bundle_new_release'

