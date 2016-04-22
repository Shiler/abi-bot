require './lib/constants.rb'
require './lib/console.rb'
require './lib/methods.rb'
require './lib/external_resources.rb'
require './lib/send_welcome_task.rb'
require './lib/send_exchange_rates_task.rb'
require './lib/send_weather_task.rb'
require './lib/long_poll.rb'
require 'date'

class TaskManager

  def initialize(token)
    @tasks      = Queue.new
    @time_tasks = Array.new
    @running    = false
    @token      = token
    @data       = ExternalResources.get
    @long_poll  = LongPoll.new(token)
  end

  def start
    Console.tm_started
    @running = true
    while @running do
      do_task(next_task)
      check_time_tasks
      sleep(1/RequestsPerSecond)
    end
  end

  def add_default_tasks
    sleep 1/RequestsPerSecond
    friends = Methods.get_friends(@token)
    friends.each do |id|
      unless WhiteList.include? id
        add_task(SendWelcomeTask.new(id, @token))
        add_time_task(SendWeatherTask.new(id, @token, @data[:weather]))
        add_time_task(SendExchangeRatesTask.new(id, @token, @data[:rates]))
      end
    end
  end

  def stop
    @running = false
  end

  def do_task(task)
    unless task.nil?
      Console.task_running(task.class.to_s)
      task.run
    end
  end

  def add_task(task)
    @tasks << task
    Console.added_task(task.class.to_s)
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