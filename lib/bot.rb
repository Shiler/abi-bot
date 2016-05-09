require_relative 'task_manager.rb'
require_relative 'console.rb'

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