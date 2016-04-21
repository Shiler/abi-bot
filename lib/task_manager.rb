require './lib/constants.rb'
require './lib/send_exchange_rates_task.rb'
require './lib/console.rb'
require './lib/rates.rb'
require 'time'
require 'date'
require 'colorize'

class TaskManager

  def initialize(token)
    @tasks    = Array.new
    @running  = false
    @token    = token
    @console  = Console.new
    @time_tasks = Array.new
  #  @task1    = SendExchangeRatesTask.new(143937778, @token,"21:20")
  #  @task2    = SendExchangeRatesTask.new(95679514,@token,"21:20")
  end

  def start
    @console.tm_started
    @running = true
    adding_tasks
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

  def adding_tasks
       Members.each do |id|
          @time_tasks.push(SendExchangeRatesTask.new(id))
        end
      @time_tasks.each do |task|
        puts task.executed.to_s.red
        end
      #sort_tasks_by_time   #add_task()
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
