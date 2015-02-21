root = '/apps/sms/current'
#root = '/Volumes/CodeZone/twilio/attendant'
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

worker_processes 4
timeout 180

environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'production'

# Save on RAM while in development
if environment == 'development'
  worker_processes 4
  listen '172.31.35.52:9000'
elsif environment == 'production'
  listen '172.31.35.52:9000'
  worker_processes 8
end


#timeout 60
preload_app true
@delayed_job_pid = nil
before_fork do |server, worker|
  # Close all open connections
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
  @delayed_job_pid ||= spawn('scripts/delayed_job stop ; scripts/delayed_job start')
end

after_fork do |server, worker|
  # Reopen all connections
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
