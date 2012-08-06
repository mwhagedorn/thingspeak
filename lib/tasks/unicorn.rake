namespace :unicorn do

  desc "Start unicorn"
  task(:start) {
    config = "#{Rails.root}/config/unicorn.rb"
    sh "cd #{Rails.root}; unicorn_rails --daemonize --config-file #{config} -E production"
    p "Unicorn started"
  }

  desc "Stop unicorn"
  task(:stop) {
    unicorn_signal :QUIT
    p "Unicorn stopped"
  }

  desc "Restart unicorn with USR2"
  task(:restart) do
    unicorn_signal :USR2
    p "Unicorn restarted"
  end

  desc "Increment number of worker processes"
  task(:increment) do
    unicorn_signal :TTIN
    p "Started owe more Unicorn worker"
  end

  desc "Decrement number of worker processes"
  task(:decrement) do
    unicorn_signal :TTOU
    p "Stopped one Unicorn worker"
  end

  desc "Unicorn pstree (depends on pstree command)"
  task(:pstree) do
    sh "pstree '#{unicorn_pid}'"
  end

  # Helpers

  def unicorn_signal signal
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    begin
      File.read("#{Rails.root}/tmp/pids/unicorn.pid").to_i
    rescue Errno::ENOENT
      raise "Unicorn doesn't seem to be running"
    end
  end

end