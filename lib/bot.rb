require_relative 'task_manager.rb'
require_relative 'console.rb'
require_relative 'constants.rb'

class Bot

  def initialize
    @task_manager = TaskManager.new(TOKEN)
  end

  def start
    @task_manager.start
  end

  def stop
    @task_manager.stop
    Console.stopped
  end

end
