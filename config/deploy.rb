set :application, "thehealthcare"
set :repository,  "git@github.com:supriyak/refinery_repo.git"
set :deploy_to,  "/ebs/apps/#{application}"
set :applicationdir,  "/ebs/apps/#{application}"

set :use_sudo, false
set :scm, :git
set :keep_releases, 3
set :rails_env, "production"

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`


# deploy config
set :deploy_to, applicationdir
set :deploy_via, :export

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows

#ssh_options[:keys] = %w(/Path/To/id_rsa)            # If you are using ssh_keys
#set :chmod755, "app config db lib public vendor script script/* public/disp*"
#set :use_sudo, true

after "deploy:update_code", "deploy:copy_configs"

task :qa do
  set :domain, "23.23.227.17"
  set :user, "root"
  set :branch, "master"
  set :scm_verbose, true
  role :web, domain
  role :app, domain
  role :db, domain, :primary=>true
  set :deploy_env, "qa"
  # deploy config

  "deploy"

end

namespace :deploy do

  task :copy_configs, :roles => :app do
    run "cp #{release_path}/../../shared/database.yml #{release_path}/config/database.yml"
  end

  task :migrate, :roles => :app do
    run "cd #{release_path} && rake db:migrate"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do

  end

 #task :pipeline_precompile do
  #  run "cd #{release_path}; /usr/local/rvm/gems/ruby-1.9.2-p290/bin/bundle install"
  #  run "cd #{release_path}; /usr/local/rvm/gems/ruby-1.9.2-p290/bin/bundle exec rake RAILS_ENV=production RAILS_GROUPS=assets assets:precompile"
  #end
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      logger.info "Skipping asset pre-compilation because there were no asset changes"
    end
  end
end

after "deploy:update","deploy:migrate","deploy:cleanup"

