require 'colorize'
require './lib/constants.rb'
require 'slop'

class Console

  def Console.get_parameters
    opts = Slop.parse do |o|
      o.string '...'
    end
    opts
  end

  def Console.get_token
    #url = get_parameters.arguments[0]
    #arr = url.scan(/#access_token=(.*)&expires_in=/).flatten
    #if (!arr.any?)
    #  bad_url
    #end
    #arr.first
    TOKEN
  end

  # ---- notifications block ----

  def Console.bad_url
    puts 'Url is not valid! Please, check it and run script again.'.colorize(:red)
    exit
  end

  def Console.stopped
    puts 'Bot stopped.'.colorize(:red)
  end

  def Console.task_running(name)
    puts "Running task: #{name}".colorize(:yellow)
  end

  def Console.tm_started
    puts 'Task manager started.'.colorize(:blue)
  end

  def Console.added_task(name)
    puts "Added task: #{name}".colorize(:green)
  end

  def Console.long_poll_started
    puts 'Long Poll listener started.'.colorize(:blue)
  end

  def Console.rates_loaded
    puts 'Rates loaded.'.colorize(:blue)
  end

  def Console.weather_loaded
    puts 'Weather loaded.'.colorize(:blue)
  end

  def Console.available_commands(commands)
    str = ''
    commands.each do |item|
      str += "/#{item}\s"
    end
    puts "Available commands: #{str}".colorize(:blue)
  end

  def Console.calls(count)
    puts "Calls: #{count}".colorize(:blue)
  end

end
