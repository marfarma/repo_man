set :application, "repo_man"
set :use_sudo, false
set :repository, "git://git.lab.viget.com/#{application}.git"
set :deploy_to, "/var/www/#{application}/production"

role :web, "sapporo.lab.viget.com"
role :app, "sapporo.lab.viget.com"
role :db,  "sapporo.lab.viget.com", :primary => true

set :user, "apache"

set :scm, "git"
set :branch, "master"
set :checkout, "export"

set :default_stage, "production"

set :symlinks, %w(config/database.yml config/site.yml)

namespace :deploy do
  task :after_default, :roles => :web do
    run "cd #{release_path} && gem build repo_man.gemspec && mv *gem public"
  end
end