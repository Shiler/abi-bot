require './lib/methods.rb'
require './lib/constants.rb'

class GetFriendsTask

  def initialize(token)
    @exec_time = MorningTime
    @executed = false
    @token = token
  end

end