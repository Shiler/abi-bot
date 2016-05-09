require 'date'

class BasicTimeTask

  def initialize(*)
    @exec_time = MorningTime
    @executed = false
  end

  def exec_time
    @exec_time
  end

  def set_executed(bool)
    @executed = bool
  end

  def executed?
    @executed
  end

end