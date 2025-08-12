app_path = File.expand_path('../../../../', __FILE__)

current = "#{app_path}/current"
shared  = "#{app_path}/shared"

worker_processes 2
working_directory current

listen      "#{shared}/tmp/sockets/unicorn.sock"
pid         "#{shared}/tmp/pids/unicorn.pid"
stderr_path "#{shared}/log/unicorn.stderr.log"
stdout_path "#{shared}/log/unicorn.stdout.log"

timeout 60
preload_app true
check_client_connection false

before_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end


