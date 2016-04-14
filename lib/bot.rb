class Bot

  def initialize(token)
    @token = token
    @synchronizer = Synchronizer.new
    @task_manager = TaskManager.new
  end

  def start()
    @task_manager.start
  end

  def stop()

  end

end