require_relative 'constants.rb'
require_relative 'console.rb'
require_relative 'methods.rb'
require_relative 'external_resources.rb'
require_relative 'time_tasks/send_welcome_task.rb'
require_relative 'time_tasks/send_exchange_rates_task.rb'
require_relative 'time_tasks/send_weather_task.rb'
require_relative 'long_poll.rb'
require_relative 'time_tasks/send_new_features_task.rb'
require_relative 'lp_updates_manager.rb'
require_relative 'message_processor.rb'
require 'date'
require 'colorize'

class TaskManager

  attr_accessor :data
  def initialize(token)
    @tasks        = Queue.new
    @time_tasks   = Array.new
    @running      = false
    @token        = token
    @data         = ExternalResources.get
    @long_poll    = LongPoll.new(token)
    @mp           = MessageProcessor.new(token)
    @messages     = Queue.new
    @mutex        = Mutex.new
    @com_calls    = 0
  end

  def start
    @running = true
    long_poll_thread
    while @running do
      process_messages
      do_task(next_task)
      check_time_tasks
      sleep(1/RequestsPerSecond)

      if Thread.list.count == 1 || Thread.list.last == nil
        long_poll_thread
      end
    end
  end

  def long_poll_thread
    Thread.new do
      @mutex.synchronize do
        updates = @long_poll.get_updates
        LPUpdatesManager.get_messages(updates).each do |message|
          @messages << message
        end
      end
    end
  end

  def process_messages
    until @messages.empty?
      message = @messages.pop
      task = @mp.make_task(message)
      add_task(task)
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
    unless task.nil?
      @tasks << task
      Console.added_task(task.class.to_s)
    end
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
    reset_execution_status
  end

  def reset_execution_status
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
