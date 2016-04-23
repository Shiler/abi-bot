require './lib/constants.rb'
require './lib/send_exchange_rates_task.rb'
require './lib/console.rb'
require 'time'
require 'colorize'
require './lib/good_morning.rb'
require '../lib/long_poll'

class TaskManager

  def initialize(token)
    @tasks    = Array.new
    @running  = false
    @token    = token
    @console  = Console.new
    @time_tasks = Array.new

  end

  def start
    @console.tm_started
    @running = true
    add_tasks_to_queue
    while (@running) do
      do_task(next_task)
      sleep(1/RequestsPerSecond)
      check_time_tasks
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
    @tasks.push(task)
  end

  def next_task
    @tasks.empty? ? nil : @tasks.pop
  end

  def add_tasks_to_queue
    Members.each do |id|
      @time_tasks.push(SendExchangeRatesTask.new(id, @token))
    end
    Members.each do |id|
      @time_tasks.push(SendGoodMorningTask.new(id, @token))
    end
  end

  def  check_time_tasks
    @time_tasks.each do |task|
      if  Time.now.hour == Time.parse(task.leadtime).hour && Time.now.min == Time.parse(task.leadtime).min && !task.executed
        #check for new tasks
        add_task(task)
        task.executed = true
      end

      if Time.now.hour == Time.parse(task.leadtime).hour && Time.now.min > Time.parse(task.leadtime).min && task.executed
        task.executed = false
      end
    end
  end

end