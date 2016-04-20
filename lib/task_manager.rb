require './lib/constants.rb'
require './lib/send_exchange_rates_task.rb'
require './lib/console.rb'
require './lib/rates.rb'
require 'date'

class TaskManager

  def initialize(token)
    @tasks      = Queue.new
    @time_tasks = Array.new
    @running    = false
    @token      = token
    @console    = Console.new
    @rates      = Rates.new.get_rates
  end

  def start
    @console.tm_started
    @running = true
    add_currency_tasks
    while (@running) do
      do_task(next_task)
      check_time_tasks
      sleep(1/RequestsPerSecond)
    end
  end

  def add_currency_tasks
    Users.each do |id|
      add_time_task(SendExchangeRatesTask.new(id, @token, @rates))
    end
  end

  def stop
    @running = false
  end

  def do_task(task)
    if (!task.nil?)
      @console.task_running(task.class.to_s)
      task.run
    end
  end

  def add_task(task)
    @tasks << task
  end

  def add_time_task(time_task)
    @time_tasks << time_task
  end

  def check_time_tasks
    if (@time_tasks.empty?)
      return nil
    end
    time_now = Time.now
    @time_tasks.each do |elem|
      if (time_now.hour == elem.exec_time.hour && time_now.min == elem.exec_time.min && !elem.executed?)
        elem.set_executed(true)
        add_task(elem)
      end
    end
    check_execution
  end

  def check_execution
    time_now = Time.now
    @time_tasks.each do |elem|
      if (time_now.hour == elem.exec_time.hour && time_now.min > elem.exec_time.min && !elem.executed?)
        elem.set_executed(false)
      end
    end
  end

  def next_task
    @tasks.empty? ? nil : @tasks.pop
  end

end