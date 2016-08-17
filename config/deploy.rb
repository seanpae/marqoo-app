# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'marqoo-app'
set :deploy_user, 'ubuntu'
set :repo_url, 'git@github.com:seanpae/marqoo-app.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:application)}"
set :migrate_target,  :current
set :rails_env, "production"
set :rvm1_ruby_version, "2.3.1"
set :pty, true 
set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey),
  keys: %w(/home/anuj/Downloads/marqooapp.pem)
}

# Default value for :scm is :git
set :scm, :git


# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml','config/application.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :resque_rails_env, "production"

namespace :bundle do
  task :update do
    on roles(:app) do
      within "#{release_path}" do
        execute :bundle , "install --without development test"
      end
    end
  end
end

namespace :deploy do

  desc 'Runs rake db:create'
    task :create => [:set_rails_env] do
      on primary fetch(:migration_role) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "db:create RAILS_ENV=#{fetch(:rails_env)}"
          end
        end
      end
    end

  desc "Updates Cron tab"
  task :update_crontab do
    on roles(:db) do
      within "#{release_path}" do
        execure :bundle , "exec whenever --update-crontab #{fetch(:application)}"
      end
    end
  end
end

before "deploy:updated", "bundle:update"

