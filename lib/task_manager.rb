require './lib/constants.rb'
require './lib/send_exchange_rates_task.rb'
require './lib/send_weather_task.rb'
require './lib/console.rb'
require './lib/rates.rb'
require './lib/weather.rb'
require './lib/methods.rb'
require './lib/send_welcome_task.rb'
require 'date'

class TaskManager

  def initialize(token)
    @tasks      = Queue.new
    @time_tasks = Array.new
    @running    = false
    @token      = token
    @methods    = Methods.new
    @console    = Console.new
    @rates      = Rates.new.get_rates
    @weather    = Weather.new.get_weather
  end

  def start
    @console.tm_started
    @running = true
    add_welcome_tasks
    add_weather_tasks
    add_currency_tasks
    while @running do
      do_task(next_task)
      check_time_tasks
      sleep(1/RequestsPerSecond)
    end
  end

  def add_currency_tasks
    sleep 1/RequestsPerSecond
    friends = @methods.get_friends(@token)
    # friends = [95679514, 143937778] # test
    friends.each do |id|
      add_time_task(SendExchangeRatesTask.new(id, @token, @rates))
    end
  end

  def add_welcome_tasks
    sleep 1/RequestsPerSecond
    friends = @methods.get_friends(@token)
    # friends = [95679514, 143937778] # test
    friends.each do |id|
      add_time_task(SendWelcomeTask.new(id, @token))
    end
  end

  def add_weather_tasks
    sleep 1/RequestsPerSecond
    friends = @methods.get_friends(@token)
    # friends = [95679514, 143937778] # test
    friends.each do |id|
      add_time_task(SendWeatherTask.new(id, @token, @weather))
    end
  end

  def stop
    @running = false
  end

  def do_task(task)
    unless task.nil?
      @console.task_running(task.class.to_s)
      task.run
    end
  end

  def add_task(task)
    @tasks << task
    @console.added_task(task.class.to_s)
  end

  def add_time_task(time_task)
    @time_tasks << time_task
  end

  def check_time_tasks
    if @time_tasks.empty?
      return nil
    end
    time_now = Time.now
    @time_tasks.each do |elem|
      if time_now.hour == elem.exec_time.hour && time_now.min == elem.exec_time.min && !elem.executed?
        elem.set_executed(true)
        add_task(elem)
      end
    end
    check_execution
  end

  def check_execution
    time_now = Time.now
    @time_tasks.each do |elem|
      if time_now.hour == elem.exec_time.hour && time_now.min > elem.exec_time.min && !elem.executed?
        elem.set_executed(false)
      end
    end
  end

  def next_task
    @tasks.empty? ? nil : @tasks.pop
  end

end