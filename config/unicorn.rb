# config/unicorn.rb
app_path = "/var/www/furima-42334"

worker_processes 2
working_directory "#{app_path}/current"

listen "/var/www/furima-42334/shared/tmp/sockets/unicorn.sock"
pid         "/var/www/furima-42334/shared/tmp/pids/unicorn.pid"
stderr_path "/var/www/furima-42334/shared/log/unicorn.stderr.log"
stdout_path "/var/www/furima-42334/shared/log/unicorn.stdout.log"

timeout 60
preload_app true
check_client_connection false

before_fork do |_server, _worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
end

after_fork do |_server, _worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
