require 'concurrent'

class Test
  include Concurrent::Async

  def method1
    puts 'one'
    sleep 1
  end

  def method2
    puts 'two'
    sleep 3
  end

end

test = Test.new

while(true)
  test.async.method1
  test.async.method2
end