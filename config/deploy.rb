require "bundler/capistrano"

# General
set :application,         "simontime"
set :domain,              "www.tinycat.co.uk"
set :user,                "simon"
set :runner,              "simon"
set :use_sudo,            false
set :deploy_to,           "/var/www/#{application}"

# Roles
role :web,                domain

# GIT
set :repository,          "git@github.com:siclark/st-blog.git" 
set :branch,              "master"
set :keep_releases,       3
set :deploy_via,          :remote_cache
set :scm,                 :git

# SSH
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:paranoid] = true 

namespace :octopress do
  task :generate, :roles => :web do
    run "cd #{release_path} && bundle exec rake generate"
  end
end

after 'deploy:create_symlink', 'deploy:cleanup'
after 'bundle:install', 'octopress:generate'