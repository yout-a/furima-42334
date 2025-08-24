lock "~> 3.19.0"

set :application, "furima-42334"
set :repo_url, "git@github.com:yout-a/furima-42334.git"
set :branch, "main"

append :linked_files, "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets",
                     "public/system", "storage"

set :rbenv_type, :user
set :rbenv_ruby, "3.2.3"

set :ssh_options, auth_methods: ['publickey'],
                                  keys: ['~/.ssh/my-key-pair.pem']

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

set :log_level, :info
set :format_options, truncate: false

namespace :unicorn do
  desc "Restart unicorn via systemd"
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, "unicorn-furima"
    end
  end
end

after "deploy:published", "unicorn:restart"

