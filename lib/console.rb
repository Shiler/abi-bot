 require 'colorize'
require 'slop'

class Console

  def get_parameters
    opts = Slop.parse do |o|
      o.string '...'
    end
    opts
  end

  def get_token
    url = get_parameters.arguments[0]
    arr = url.scan(/#access_token=(.*)&expires_in=/).flatten
    puts arr
    if (!arr.any?)
      bad_url
    end
    arr.first
  end

  # ---- notifications block ----

  def bad_url
    puts 'Url is not valid! Please, check it and run script again.'.colorize(:red)
    exit
  end

  def stopped
    puts 'Bot stopped.'.colorize(:red)
  end

  def task_running(name)
    puts "Running task: #{name}".colorize(:yellow)
  end

  def tm_started
    puts 'Task manager started.'.colorize(:blue)
  end

  def added_task(name)
    puts "Added task: #{name}".colorize(:green)
  end

end
