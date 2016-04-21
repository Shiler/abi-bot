require './lib/task_manager.rb'
require './lib/console.rb'

class Bot

  def initialize(token)
    @task_manager = TaskManager.new(token)
    @console      = Console.new
  end

  def start
    @task_manager.start
  end

  def stop
    @task_manager.stop
    @console.stopped
  end

end