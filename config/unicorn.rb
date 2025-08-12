app_path = "/var/www/furima-42334"

worker_processes 2

working_directory "#{app_path}/current"

listen "#{app_path}/shared/tmp/sockets/unicorn.sock"

pid         "#{app_path}/shared/tmp/pids/unicorn.pid"
stderr_path "#{app_path}/shared/log/unicorn.stderr.log"
stdout_path "#{app_path}/shared/log/unicorn.stdout.log"

timeout 60
preload_app true
check_client_connection false

before_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
