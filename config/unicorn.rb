app_path = "/home/ubuntu/apps/marqoo-app/current"
stderr_path "/home/ubuntu/apps/marqoo-app/log/unicorn.stderr.log"
##pid   "#{app_path}/current/tmp/pids/unicorn.pid"
pid   "#{app_path}/tmp/pids/unicorn.pid"
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 4)

listen "/tmp/unicorn.marqooapp.sock", :backlog => 64

# use correct Gemfile on restarts
before_exec do |server|
  ##ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/Gemfile"
end

preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
