require './lib/constants.rb'
require './lib/send_exchange_rates_task.rb'
require './lib/console.rb'
require './lib/rates.rb'

class TaskManager

  def initialize(token)
    @tasks    = Queue.new
    @running  = false
    @token    = token
    @console  = Console.new
    @rates    = Rates.new.get_rates
  end

  def start
    @console.tm_started
    @running = true
    add_task(SendExchangeRatesTask.new(143937778, @token, @rates))
    while (@running) do
      do_task(next_task)
      sleep(100/RequestsPerSecond)
    end
  end

  def stop
    @running = false
  end

  def do_task(task)
    if (!task.nil?)
      task.run
      @console.task_running(task.class.to_s)
    end
  end

  def add_task(task)
    @tasks << task
  end

  def next_task
    @tasks.empty? ? nil : @tasks.pop
  end

end