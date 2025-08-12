app_path = File.expand_path('../../..', __FILE__)
current  = "#{app_path}/current"
shared   = "#{app_path}/shared"

worker_processes 2

working_directory current

listen "#{shared}/tmp/sockets/unicorn.sock"

pid         "#{shared}/tmp/pids/unicorn.pid"
stderr_path "#{shared}/log/unicorn.stderr.log"
stdout_path "#{shared}/log/unicorn.stdout.log"

timeout 60
preload_app true
check_client_connection false

before_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end



