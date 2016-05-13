require './lib/methods.rb'
require './lib/constants.rb'

class SendNewFeaturesTask

  def initialize(id, token)
    @id = id
    @token = token
    @features = IO.readlines('features.txt').join do |result, elem|
      result += "#{elem}\n"
    end
  end

  def run
    message = @features
    Methods.send_message(@id, message, @token)
  end

end