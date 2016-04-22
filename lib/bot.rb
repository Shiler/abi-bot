require './lib/task_manager.rb'
require './lib/console.rb'

class Bot

  def initialize(token)
    @task_manager = TaskManager.new(token)
  end

  def start
    @task_manager.start
  end

  def stop
    @task_manager.stop
    Console.stopped
  end

end