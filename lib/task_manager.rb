require './lib/constants.rb'
require './lib/console.rb'
require './lib/methods.rb'
require './lib/external_resources.rb'
require './lib/send_welcome_task.rb'
require './lib/send_exchange_rates_task.rb'
require './lib/send_weather_task.rb'
require './lib/long_poll.rb'
require './lib/lp_updates_manager.rb'
require './lib/command_processor.rb'
require './lib/send_new_features_task.rb'
require 'date'
require 'colorize'
require 'monitor'

class TaskManager

  POOL_SIZE = 10

  attr_accessor :data
  def initialize(token)
    @tasks      = Queue.new
    @time_tasks = Array.new
    @running    = false
    @token      = token
    @data       = ExternalResources.get
    @long_poll  = LongPoll.new(token)
    @lp_manager = LPUpdatesManager.new
    @cp         = CommandProcessor.new(token)
    @messages   = Queue.new
    @commands   = Queue.new
    @jobs       = Queue.new
    @mutex      = Mutex.new
  end

  def start
    @running = true
    # send_new_features_notification
    long_poll_thread
    while @running do
      process_messages
      commands_to_tasks
      do_task(next_task)
      check_time_tasks
      sleep(1/RequestsPerSecond)

      if Thread.list.count == 1 || Thread.list.last == nil
        long_poll_thread
      end
    end
  end



  def send_new_features_notification
    sleep 1/RequestsPerSecond
    friends = Methods.get_friends(@token)
    friends.each do |id|
      unless WhiteList.include? id
        add_task(SendNewFeaturesTask.new(id, @token))
      end
    end
  end

  def long_poll_thread
    Thread.new do
      @mutex.synchronize do
        LPUpdatesManager.get_messages(@long_poll.get_updates).each do |message|
          @messages << message
        end
      end
    end
  end

  def commands_to_tasks
    until @commands.empty? do
      add_task(@cp.make_task(@commands.pop))
    end
  end

  def process_messages
    until @messages.empty?
      message = @messages.pop
      if @cp.is_command?(message)
        @commands << @cp.process(message)
        puts @cp.process(message).to_s
      end
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