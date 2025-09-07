lock "~> 3.19.0"

set :application, "furima-42334"
set :repo_url, "git@github.com:yout-a/furima-42334.git"
set :branch, "main"
set :deploy_to,   '/var/www/furima-42334'

set :rbenv_type,  :user
set :rbenv_ruby, "3.2.3"

append :linked_files, 'config/database.yml', 'config/master.key', 'config/unicorn.rb'
append :linked_dirs,  'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/assets', 'public/system', 'storage'


set :keep_releases, 5
set :log_level, :info

set :unicorn_pid,         "#{shared_path}/tmp/pids/unicorn.pid"
set :unicorn_config_path, "#{shared_path}/config/unicorn.rb"
set :unicorn_rack_env,    'production'

after 'deploy:publishing', 'unicorn:restart'

namespace :deploy do
  # 古いリリースを自動削除
  after :finishing, 'deploy:cleanup'

  # アセット掃除
  desc 'Clean old compiled assets'
  task :clean_assets do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rails assets:clean'
        end
      end
    end
  end
end

# precompile の後に assets:clean を実行
after 'deploy:assets:precompile', 'deploy:clean_assets'


