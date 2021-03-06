require_relative 'message.rb'


class LPUpdatesManager

  def LPUpdatesManager.get_messages(updates)
    new_messages = []
    updates.each do |update|
      update.first == 4 ? new_messages << Message.new(update[1], update[3], update[6]) : nil
    end
    new_messages
  end

end